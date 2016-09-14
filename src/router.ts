/**
 * Routes
 */

import * as express from 'express';

import signin from './core/signin';
import config from './config';
import api from './core/api';

const subdomainPrefix = '__';

const aboutDomain = `/${subdomainPrefix}/about`;
const colorDomain = `/${subdomainPrefix}/color`;
const signupDomain = `/${subdomainPrefix}/signup`;
const signinDomain = `/${subdomainPrefix}/signin`;
const signoutDomain = `/${subdomainPrefix}/signout`;

export default function(app: express.Express): void {

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

	app.get('/:username', async (req, res) => {
		const user = await api('users/show', {
			username: req.params.username
		});
		render(req, res, 'user', {
			user: user
		});
	});

	app.get(`${aboutDomain}/staff`, (req, res) => {
		renderAbout(req, res, 'staff');
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
			res.clearCookie('i', {
				path: '/',
				domain: `.${config.host}`
			});
		}
		res.redirect(config.url);
	});

	/**
	 * API handlers
	 */
	app.post('/_/api/url', require('./api/url').default);
	app.get('/_/proxy/:url(*)', require('./api/proxy').default);
	app.get('/_/api/rss-proxy/:url(*)', require('./api/rss-proxy').default);

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

function renderAbout(req: express.Request, res: express.Response, path: string): void {
	res.render(`${__dirname}/web/common/pages/about/pages/${path}`);
}
