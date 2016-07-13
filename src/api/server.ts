//////////////////////////////////////////////////
// API SERVER
//////////////////////////////////////////////////

import * as express from 'express';
import * as expressSession from 'express-session';
import * as bodyParser from 'body-parser';
import * as cookieParser from 'cookie-parser';
import * as csrf from 'csurf';
import * as cors from 'cors';

import config from '../config';

import router from './router';

export default (session: any) => {
	// Init server
	const app = express();
	app.disable('x-powered-by');

	app.use(bodyParser.urlencoded({ extended: true }));
	app.use(cookieParser(config.cookiePass));

	// Session settings
	app.use(expressSession(session));

	// CSRF
	app.use(csrf({
		cookie: false
	}));

	// CORS
	app.use(cors({
		origin: true,
		credentials: true
	}));

	app.use((req, res, next) => {
		res.header('X-Frame-Options', 'DENY');
		next();
	});

	router(app);

	return app;
};
