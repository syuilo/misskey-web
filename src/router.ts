/**
 * Routes
 */

import * as express from 'express';
import * as ms from 'ms';

import signin from './core/signin';
import config from './config';

const subdomainPrefix = '__';

const mobileDomain = `/${subdomainPrefix}/mobile`;
const signupDomain = `/${subdomainPrefix}/signup`;
const signinDomain = `/${subdomainPrefix}/signin`;
const signoutDomain = `/${subdomainPrefix}/signout`;

const router = express.Router();

router.post(`${signupDomain}/`, require('./core/signup').default);

router.post(`${signinDomain}/`, (req, res) => {
	signin(req.body.username, req.body.password, res);
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
router.post('/_/api/rss-proxy', require('./api/rss-proxy').default);

router.get(`${mobileDomain}/*`, (req, res) => {
	res.sendFile(`${__dirname}/web/mobile/view.html`, {
		maxAge: ms('7 days')
	});
});

router.get('*', (req, res) => {
	res.sendFile(`${__dirname}/web/desktop/view.html`, {
		maxAge: ms('7 days')
	});
});

export default router;
