/**
 * Web server
 */

// Core modules
import * as fs from 'fs';
import * as http from 'http';
import * as https from 'https';

// express modules
import * as express from 'express';
import * as compression from 'compression';
import * as bodyParser from 'body-parser';
import * as cookieParser from 'cookie-parser';
import * as cors from 'cors';
import * as favicon from 'serve-favicon';
const subdomain = require('subdomain');

import manifest from './utils/manifest';
import appleTouchIcon from './utils/apple-touch-icon';

// Utility module
import * as ms from 'ms';

// Internal modules
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
app.use(manifest);
app.use(appleTouchIcon);
app.use('/_/resources', express.static(`${__dirname}/resources`, {
	maxAge: ms('7 days')
}));

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
 * Initialize requests
 */
app.use((req, res, next) => {
	res.header('X-Frame-Options', 'DENY');
	const i = req.cookies['i'];
	res.locals.signin = i !== undefined;
	next();
});

/**
 * Subdomain
 */
app.use(subdomain({
	base: config.host,
	prefix: '__'
}));

/**
 * Routing
 */
app.use(router);

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
