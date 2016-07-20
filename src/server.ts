const env = process.env.NODE_ENV;

/**
 * Module dependencies
 */
import * as cluster from 'cluster';
import * as fs from 'fs';
import * as http from 'http';
import * as https from 'https';
import * as express from 'express';
import * as expressSession from 'express-session';
import * as useragent from 'express-useragent';
import * as MongoStore from 'connect-mongo';
import * as compression from 'compression';
import * as bodyParser from 'body-parser';
import * as cookieParser from 'cookie-parser';
import * as cors from 'cors';
import * as csrf from 'csurf';
import * as favicon from 'serve-favicon';
import * as accesses from 'accesses';
import name from 'named';

import db from './db/db';
import UserSetting from './db/models/user-settings';
import api from './core/api';
import config from './config';
import router from './router';

const worker = cluster.worker;
console.log(`Init ${name(worker.id)} server...`);

/**
 * Options
 */

const store = MongoStore(expressSession);

const sessionExpires = 1000 * 60 * 60 * 24 * 365; // One Year

const cookieBase = {
	path: '/',
	domain: `.${config.host}`,
	secure: config.https.enable
};

const session = {
	name: 's',
	secret: config.sessionSecret,
	resave: false,
	saveUninitialized: true,
	cookie: Object.assign({
		httpOnly: true,
		expires: new Date(Date.now() + sessionExpires),
		maxAge: sessionExpires
	}, cookieBase),
	store: new store({
		mongooseConnection: db
	})
};

/**
 * Init app
 */
const app = express();
app.disable('x-powered-by');
app.locals.compileDebug = false;
app.locals.cache = true;
app.locals.env = env;
// app.locals.pretty = '    ';
app.set('views', __dirname);
app.set('view engine', 'pug');

/**
 * Logging
 */
app.use(accesses.express());

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
app.use('/_/resources', express.static(`${__dirname}/resources`));
app.use(favicon(`${__dirname}/resources/favicon.ico`));
app.get('/manifest.json', (req, res) => res.sendFile(__dirname + '/resources/manifest.json'));
app.get('/apple-touch-icon.png', (req, res) => res.sendFile(__dirname + '/resources/apple-touch-icon.png'));

/**
 * Basic parsers
 */
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cookieParser(config.cookiePass));

/**
 * Session
 */
app.use(expressSession(session));

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
app.use(async (req, res, next): Promise<void> => {

	// Security headers
	res.header('X-Frame-Options', 'DENY');

	// HSTS
	if (config.https.enable) {
		res.header(
			'Strict-Transport-Security',
			'max-age=15768000; includeSubDomains; preload');
	}

	// See http://web-tan.forum.impressrd.jp/e/2013/05/17/15269
	res.header('Vary', 'User-Agent, Cookie');

	res.locals.signin =
		req.hasOwnProperty('session') &&
		req.session !== null &&
		req.session.hasOwnProperty('userId') &&
		(<any>req.session).userId !== null;

	res.locals.config = config;

	// Set CSRF token to Cookie
	res.cookie('x', req.csrfToken(), Object.assign({
		httpOnly: false
	}, cookieBase));

	if (!res.locals.signin) {
		res.locals.user = null;
		return next();
	}

	try {
		// ユーザー情報フェッチ
		const user = await api('i', {}, (<any>req.session).userId);

		// ユーザー設定取得
		const settings = await UserSetting.findOne({user_id: user.id}).lean();

		res.locals.user = Object.assign(user, {_settings: settings});

		// Set user data to Cookie
		res.cookie('u', JSON.stringify(res.locals.user), Object.assign({
			httpOnly: false
		}, cookieBase));

		next();
	} catch (e) {
		res.status(500).send('Core Error');
	}
});

/**
 * Routing
 */
router(app);

/**
 * Create server
 */
const server = config.https.enable
	? https.createServer({
			key: fs.readFileSync(config.https.keyPath),
			cert: fs.readFileSync(config.https.certPath)
		}, app)
	: http.createServer(app);

/**
 * Server listen
 */
server.listen(config.bindPort, config.bindIp, () => {
	const h = server.address().address;
	const p = server.address().port;

	console.log(
		`\u001b[1;32m${name(worker.id)} is now listening at ${h}:${p}\u001b[0m`);
});
