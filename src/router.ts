/**
 * Routes
 */

import * as express from 'express';

import signin from './core/signin';
import config from './config';
import api from './core/api';

const subdomainPrefix = '__';

const aboutDomain = `/${subdomainPrefix}/about`;
const mobileDomain = `/${subdomainPrefix}/mobile`;
const signupDomain = `/${subdomainPrefix}/signup`;
const signinDomain = `/${subdomainPrefix}/signin`;
const signoutDomain = `/${subdomainPrefix}/signout`;

const router = express.Router();

router.post(`${signupDomain}/`, require('./core/signup').default);

router.get(`${signupDomain}/`, (req, res) => {
	if (res.locals.signin) {
		res.redirect(config.url);
	} else {
		render(req, res, 'signup');
	}
});

router.post(`${signinDomain}/`, (req, res) => {
	signin(req.body.username, req.body.password, res);
});

router.get(`${signinDomain}/`, (req, res) => {
	if (res.locals.signin) {
		res.redirect(config.url);
	} else {
		render(req, res, 'signin');
	}
});

router.get(`${signoutDomain}/`, (req, res) => {
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
router.post('/_/api/url', require('./api/url').default);
router.get('/_/proxy/:url(*)', require('./api/proxy').default);
router.get('/_/api/rss-proxy/:url(*)', require('./api/rss-proxy').default);

router.get('*', (req, res) => {
	res.render(`${__dirname}/web/desktop/view`);
});

router.get(`${mobileDomain}/*`, (req, res) => {
	res.render(`${__dirname}/web/mobile/view`);
});

/**
 * Error handler
 */
router.use((err: any, req: express.Request, res: express.Response, next: any) => {
	console.error(err);
	//render(req, res, 'error', err);
	res.render(`${__dirname}/web/error`, {
		error: err
	});
});

export default router;
