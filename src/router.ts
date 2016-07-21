//////////////////////////////////////////////////
// WEB ROUTER
//////////////////////////////////////////////////

import * as express from 'express';

import signin from './core/signin';
import config from './config';
import * as multer from 'multer';
const upload = multer({ dest: 'uploads/' });

function render(req: express.Request, res: express.Response, path: string, data?: any): void {
	const ua = res.locals.useragent.isMobile ? 'mobile' : 'desktop';
	res.render(`${__dirname}/web/${ua}/pages/${path}/view`, data);
}

const subdomainOptions = {
	base: config.host
};

export default function(app: express.Express): void {

	app.use(require('subdomain')(subdomainOptions));

	app.get('/', (req, res) => {
		if (res.locals.signin) {
			render(req, res, 'home');
		} else {
			render(req, res, 'entrance');
		}
	});

	//////////////////////////////////////////////////
	// GENERAL

	app.get('/_/terms-of-use', (req, res) => {
		render(req, res, 'terms-of-use');
	});

	//////////////////////////////////////////////////
	// COLOR

	const colorDomain = `/subdomain/${config.domains.color}`;

	app.get(`${colorDomain}/`, (req, res) => {
		render(req, res, 'color');
	});

	//////////////////////////////////////////////////
	// SIGNUP

	const signupDomain = `/subdomain/${config.domains.signup}`;

	app.get(`${signupDomain}/`, (req, res) => {
		if (res.locals.signin) {
			res.redirect(config.url);
		} else {
			render(req, res, 'signup');
		}
	});

	//////////////////////////////////////////////////
	// SIGNIN

	const signinDomain = `/subdomain/${config.domains.signin}`;

	app.post(`${signinDomain}/`, (req, res) => {
		signin(req.body['username'], req.body['password'], req.session).then(() => {
			res.sendStatus(204);
		}, err => {
			res.status(err.statusCode).send(err.body);
		});
	});

	app.get(`${signinDomain}/`, (req, res) => {
		if (res.locals.signin) {
			res.redirect(config.url);
		} else if (req.query.hasOwnProperty('username') && req.query.hasOwnProperty('password')) {
			signin(req.query['username'], req.query['password'], req.session).then(() => {
				res.redirect(config.url);
			}, err => {
				res.status(err.statusCode).send(err.body);
			});
		} else {
			render(req, res, 'signin');
		}
	});

	//////////////////////////////////////////////////
	// SIGNOUT

	const signoutDomain = `/subdomain/${config.domains.signout}`;

	app.get(`${signoutDomain}/`, (req, res) => {
		if (res.locals.signin) {
			req.session.destroy(() => {
				res.redirect(config.url);
			});
		} else {
			res.redirect(config.url);
		}
	});

	//////////////////////////////////////////////////
	// API

	app.post('/_/api/account/create', require('./api/account/create').default);
	app.post('/_/api/url/analyze', require('./api/url/analyze').default);
	app.post('/_/api/avatar/update', require('./api/avatar/update').default);
	app.post('/_/api/banner/update', require('./api/banner/update').default);
	app.post('/_/api/home/update', require('./api/home/update').default);
	app.post('/_/api/display-image-quality/update', require('./api/display-image-quality/update').default);
	app.post('/_/api/pseudo-push-notification-display-duration/update',
		require('./api/pseudo-push-notification-display-duration/update').default);
	app.post('/_/api/mobile-header-overlay/update', require('./api/mobile-header-overlay/update').default);
	app.post('/_/api/user-settings/update', require('./api/user-settings/update').default);
	app.post('/_/api/album/upload',
		upload.single('file'),
		require('./api/album/upload').default);
	app.post('/_/api/posts/create-with-file',
		upload.single('file'),
		require('./api/posts/create-with-file').default);

	// Not found handling
	app.use((req, res) => {
		res.status(404);
		render(req, res, 'not-found');
	});

	// Error handlings

	app.use((err, req, res, next) => {
		if (err.code !== 'EBADCSRFTOKEN') {
			return next(err);
		}

		// handle CSRF token errors
		res.status(403).send('form tampered with');
	});

	app.use((err, req, res, next) => {
		console.error(err);
		//render(req, res, 'error', err);
		res.render(`${__dirname}/web/error`, {
			error: err
		});
	});
}
