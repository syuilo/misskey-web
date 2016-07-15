//////////////////////////////////////////////////
// WEB SERVER
//////////////////////////////////////////////////

import * as cluster from 'cluster';
import * as fs from 'fs';
import * as http from 'http';
import * as https from 'https';
import * as path from 'path';
import * as express from 'express';
import * as expressSession from 'express-session';
import * as useragent from 'express-useragent';
import * as MongoStore from 'connect-mongo';
import * as compression from 'compression';
import * as bodyParser from 'body-parser';
import * as cookieParser from 'cookie-parser';
import * as csrf from 'csurf';
import * as favicon from 'serve-favicon';
import * as accesses from 'accesses';
import name from 'named';
const vhost = require('vhost');

import db from './db/db';
import UserSetting from './db/models/user-settings';

import api from './core/api';
import config from './config';

import webapi from './api/server';
import resources from './resources';
import router from './router';

const env = process.env.NODE_ENV;

const worker = cluster.worker;

console.log(`Init ${name(worker.id)} server...`);

//////////////////////////////////////////////////
// SERVER OPTIONS

const store = MongoStore(expressSession);

const sessionExpires = 1000 * 60 * 60 * 24 * 365; // One Year
const subdomainOptions = {
	base: config.host
};

const session = {
	name: config.sessionKey,
	secret: config.sessionSecret,
	resave: false,
	saveUninitialized: true,
	cookie: {
		path: '/',
		domain: `.${config.host}`,
		httpOnly: true,
		secure: config.https.enable,
		expires: new Date(Date.now() + sessionExpires),
		maxAge: sessionExpires
	},
	store: new store({
		mongooseConnection: db
	})
};

//////////////////////////////////////////////////
// INIT SERVER PHASE

const app = express();
app.disable('x-powered-by');
app.locals.compileDebug = false;
app.locals.cache = true;
app.locals.env = env;
// app.locals.pretty = '    ';
app.set('views', __dirname);
app.set('view engine', 'pug');

// Logging
app.use(accesses.express());

// Init API server
app.use(vhost(config.hosts.api, webapi(session)));

app.use(compression());

// Init static resources server
app.use(vhost(config.hosts.resources, resources()));

app.use(favicon(`${__dirname}/resources/favicon.ico`));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cookieParser(config.cookiePass));

// CORS
app.use((req, res, next) => {
	res.header('Access-Control-Allow-Origin', config.url);
	res.header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
	res.header('Access-Control-Allow-Headers', 'Content-Type, csrf-token');
	res.header('Access-Control-Allow-Credentials', 'true');

	// intercept OPTIONS method
	if (req.method === 'OPTIONS') {
		res.sendStatus(200);
	} else {
		next();
	}
});

// Session settings
app.use(expressSession(session));

// CSRF
app.use(csrf({
	cookie: false
}));

// Parse user agent
app.use(useragent.express());

// Intercept all requests
app.use(async (req, res, next) => {

	// Security headers
	res.header('X-Frame-Options', 'SAMEORIGIN');
	res.header('X-XSS-Protection', '1; mode=block');
	res.header('X-Content-Type-Options', 'nosniff');

	// HSTS
	if (config.https.enable) {
		res.header(
			'Strict-Transport-Security',
			'max-age=15768000; includeSubDomains; preload');
	}

	// See http://web-tan.forum.impressrd.jp/e/2013/05/17/15269
	res.header('Vary', 'User-Agent, Cookie');

	res.locals.isSignin =
		req.hasOwnProperty('session') &&
		req.session !== null &&
		req.session.hasOwnProperty('userId') &&
		(<any>req.session).userId !== null;

	const ua = res.locals.useragent.isMobile ? 'mobile' : 'desktop';

	res.locals.config = config;
	res.locals.signin = res.locals.isSignin;
	res.locals.ua = ua;
	res.locals.workerId = name(worker.id);

	res.locals.csrftoken = req.csrfToken();

	if (res.locals.isSignin) {
		const userId: string = (<any>req.session).userId;
		const user = await api('account/show', {}, userId);
		const settings = await UserSetting.findOne({user_id: userId}).lean();
		res.locals.user = Object.assign({}, user, {_settings: settings});
		res.cookie('u', JSON.stringify(res.locals.user), {
			path: '/',
			domain: `.${config.host}`,
			secure: config.https.enable,
			httpOnly: false
		});
		next();
	} else {
		res.locals.user = null;
		next();
	}
});

app.use(require('subdomain')(subdomainOptions));

app.get('/manifest.json', (req, res) => {
	res.sendFile(path.resolve(`${__dirname}/resources/manifest.json`));
});

app.get('/apple-touch-icon.png', (req, res) => {
	res.sendFile(path.resolve(`${__dirname}/resources/apple-touch-icon.png`));
});

// Main routing
router(app);

//////////////////////////////////////////////////
// LISTEN PHASE

let server: http.Server | https.Server;
let port: number;

if (config.https.enable) {
	port = config.bindPorts.https;
	server = https.createServer({
		key: fs.readFileSync(config.https.keyPath),
		cert: fs.readFileSync(config.https.certPath)
	}, app);

	// 非TLSはリダイレクト
	http.createServer((req, res) => {
		res.writeHead(301, {
			Location: config.url + req.url
		});
		res.end();
	}).listen(config.bindPorts.http);
} else {
	port = config.bindPorts.http;
	server = http.createServer(app);
}

server.listen(port, config.bindIp, () => {
	const listenhost = server.address().address;
	const listenport = server.address().port;

	console.log(
		`\u001b[1;32m${name(worker.id)} is now listening at ${listenhost}:${listenport}\u001b[0m`);
});
