/**
 * Web server
 */

// Core modules
import * as fs from 'fs';
import * as http from 'http';
import * as https from 'https';

// express modules
import * as express from 'express';
import * as useragent from 'express-useragent';
import * as compression from 'compression';
import * as bodyParser from 'body-parser';
import * as cookieParser from 'cookie-parser';
import * as cors from 'cors';
import * as favicon from 'serve-favicon';
const subdomain = require('subdomain');

// Internal modules
import api from './core/api';
import config from './config';
import router from './router';

/**
 * Init app
 */
const app = express();

app.disable('x-powered-by');

app.set('views', __dirname);
app.set('view engine', 'pug');

app.locals.config = config;
app.locals.env = process.env.NODE_ENV;
app.locals.compileDebug = false;
app.locals.cache = true;

/**
 * Subdomain
 */
app.use(subdomain({
	base: config.host,
	prefix: '__'
}));

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
 * Statics
 */
app.use(favicon(`${__dirname}/resources/favicon.ico`));
app.use('/_/resources', express.static(`${__dirname}/resources`, {
	maxAge: 1000 * 60 * 60 * 24
}));
app.get('/manifest.json', (req, res) => res.sendFile(__dirname + '/resources/manifest.json'));
app.get('/apple-touch-icon.png', (req, res) => res.sendFile(__dirname + '/resources/apple-touch-icon.png'));

/**
 * Server status
 */
//app.use(require('express-status-monitor')({
//	title: 'Misskey Web Status',
//	path: '/__/about/status'
//}));

/**
 * Basic parsers
 */
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cookieParser());

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
	//res.header('X-Frame-Options', 'DENY');

	// See http://web-tan.forum.impressrd.jp/e/2013/05/17/15269
	res.header('Vary', 'User-Agent');

	const i = req.cookies['i'];

	res.locals.signin = i !== undefined;

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
	process.send('listening');
});
