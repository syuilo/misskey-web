/**
 * Web server
 */

// Core modules
import * as cluster from 'cluster';
import * as fs from 'fs';
import * as http from 'http';
import * as https from 'https';

// express modules
import * as express from 'express';
import * as session from 'express-session';
import * as useragent from 'express-useragent';
import * as compression from 'compression';
import * as bodyParser from 'body-parser';
import * as cookieParser from 'cookie-parser';
import * as cors from 'cors';
import * as csrf from 'csurf';
import * as favicon from 'serve-favicon';
import * as redis from 'connect-redis';
const hsts = require('hsts');

// Utility modules
import name from 'named';

// Internal modules
import api from './core/api';
import config from './config';
import router from './router';

const worker = cluster.worker;
console.log(`Init ${name(worker.id)} server...`);

/**
 * Init app
 */
const app = express();

app.disable('x-powered-by');

app.set('etag', false);
app.set('views', __dirname);
app.set('view engine', 'pug');

app.locals.config = config;
app.locals.env = process.env.NODE_ENV;
app.locals.compileDebug = false;
app.locals.cache = true;

/**
 * Compressions
 */
app.use(compression());

/**
 * CORS
 */
app.use(cors({
	origin: true,
	credentials: true
}));

/**
 * HSTS
 */
app.use(hsts({
	maxAge: 1000 * 60 * 60 * 24 * 365,
	includeSubDomains: true,
	preload: true
}));

/**
 * Statics
 */
app.use(favicon(`${__dirname}/resources/favicon.ico`));
app.use('/_/resources', express.static(`${__dirname}/resources`));
app.get('/manifest.json', (req, res) => res.sendFile(__dirname + '/resources/manifest.json'));
app.get('/apple-touch-icon.png', (req, res) => res.sendFile(__dirname + '/resources/apple-touch-icon.png'));

/**
 * Basic parsers
 */
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cookieParser());

/**
 * Session
 */
const sessionExpires = 1000 * 60 * 60 * 24 * 365; // One Year
const RedisStore = redis(session);
app.use(session({
	name: 's',
	secret: 'Himasaku#06160907',
	resave: false,
	saveUninitialized: true,
	cookie: {
		path: '/',
		domain: `.${config.host}`,
		secure: config.https.enable,
		httpOnly: true,
		expires: new Date(Date.now() + sessionExpires),
		maxAge: sessionExpires
	},
	store: new RedisStore({
		host: config.redis.host,
		port: config.redis.port
	})
}));

/**
 * CSRF
 */
app.use(csrf({
	cookie: false
}));

/**
 * Parse user-agent
 */
app.use(useragent.express());

/**
 * Initialize requests
 */
app.use(async (req, res, next): Promise<any> =>
{
	// Security headers
	res.header('X-Frame-Options', 'DENY');

	// See http://web-tan.forum.impressrd.jp/e/2013/05/17/15269
	res.header('Vary', 'User-Agent, Cookie');

	// Get CSRF token
	res.locals.csrftoken = req.csrfToken();

	// Check signin
	res.locals.signin =
		req.session.hasOwnProperty('user');

	if (!res.locals.signin) {
		res.locals.user = null;
		return next();
	}

	const userId = req.session['user'];

	// Fetch user data
	try {
		res.locals.user = await api('i', {}, userId);
	} catch (e) {
		console.error(e);
		res.status(500).send('Core Error');
		return;
	}

	next();
});

/**
 * Routing
 */
router(app);

/**
 * Create server
 */
const server = config.https.enable ?
	https.createServer({
		key: fs.readFileSync(config.https.key),
		cert: fs.readFileSync(config.https.cert),
		ca: fs.readFileSync(config.https.ca)
	}, app) :
	http.createServer(app);

/**
 * Server listen
 */
server.listen(config.port, () => {
	const h = server.address().address;
	const p = server.address().port;
	console.log(`\u001b[1;32m${name(worker.id)} is now listening at ${h}:${p}\u001b[0m`);
});
