/**
 * Routes
 */

import * as express from 'express';
const subdomain = require('subdomain');

import signin from './core/signin';
import config from './config';

const subdomainOptions = {
	base: config.host,
	prefix: '__'
};

const colorDomain = `/${subdomainOptions.prefix}/color`;
const signupDomain = `/${subdomainOptions.prefix}/signup`;
const signinDomain = `/${subdomainOptions.prefix}/signin`;
const signoutDomain = `/${subdomainOptions.prefix}/signout`;

export default function(app: express.Express): void {

	app.use(subdomain(subdomainOptions));

	app.get('/', (req, res) => {
		if (res.locals.signin) {
			render(req, res, 'home');
		} else {
			render(req, res, 'entrance');
		}
	});

	app.get('/_/terms-of-use', (req, res) => {
		render(req, res, 'terms-of-use');
	});

	app.get(`${colorDomain}/`, (req, res) => {
		render(req, res, 'color');
	});

	app.post(`${signupDomain}/`, require('./core/signup').default);

	app.get(`${signupDomain}/`, (req, res) => {
		if (res.locals.signin) {
			res.redirect(config.url);
		} else {
			render(req, res, 'signup');
		}
	});

	app.post(`${signinDomain}/`, (req, res) => {
		signin(req.body.username, req.body.password, res);
	});

	app.get(`${signinDomain}/`, (req, res) => {
		if (res.locals.signin) {
			res.redirect(config.url);
		} else {
			render(req, res, 'signin');
		}
	});

	app.get(`${signoutDomain}/`, (req, res) => {
		if (res.locals.signin) {
			req.session.destroy(() => {
				res.redirect(config.url);
			});
		} else {
			res.redirect(config.url);
		}
	});

	/**
	 * API handlers
	 */
	app.post('/_/api/url/analyze', require('./api/url/analyze').default);

	/**
	 * Not found handler
	 */
	app.use((req, res) => {
		res.status(404);
		render(req, res, 'not-found');
	});

	/**
	 * Error handler
	 */
	app.use((err: any, req: express.Request, res: express.Response, next: any) => {
		console.error(err);
		//render(req, res, 'error', err);
		res.render(`${__dirname}/web/error`, {
			error: err
		});
	});
}

function render(req: express.Request, res: express.Response, path: string, data?: any): void {
	const ua = res.locals.useragent.isMobile ? 'mobile' : 'desktop';
	res.render(`${__dirname}/web/${ua}/pages/${path}/view`, data);
}
