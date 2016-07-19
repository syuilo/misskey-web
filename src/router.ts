//////////////////////////////////////////////////
// WEB ROUTER
//////////////////////////////////////////////////

import * as express from 'express';

import { User } from './db/models/user';
import api from './core/api';
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

	app.param('username', paramUsername);
	app.param('postId', paramPostId);
	app.param('fileId', paramFileId);
	app.param('folderId', paramFolderId);
	app.param('talkGroupId', paramTalkGroupId);

	app.get('/', (req, res) => {
		if (res.locals.signin) {
			render(req, res, 'home');
		} else {
			render(req, res, 'entrance');
		}
	});

	//////////////////////////////////////////////////
	// GENERAL

	app.get('/terms-of-use', (req, res) => {
		render(req, res, 'terms-of-use');
	});

	//////////////////////////////////////////////////
	// I

	app.get('/i/*', (req, res, next) => {
		if (res.locals.signin) {
			next();
		} else {
			render(req, res, 'signin');
		}
	});

	app.get('/i/post', (req, res) => {
		render(req, res, 'i/post');
	});

	app.get('/i/mentions', (req, res) => {
		render(req, res, 'i/mentions');
	});

	app.get('/i/notifications', (req, res) => {
		render(req, res, 'i/notifications');
	});

	app.get('/i/album', (req, res) => {
		render(req, res, 'i/album');
	});

	app.get('/i/album/file/:fileId', (req, res) => {
		render(req, res, 'i/album/file');
	});

	app.get('/i/album/file/:fileId/edit-tag', (req, res) => {
		render(req, res, 'i/album/file/edit-tag');
	});

	app.get('/i/album/folder/:folderId', (req, res) => {
		render(req, res, 'i/album/folder');
	});

	app.get('/i/album/tags', (req, res) => {
		render(req, res, 'i/album/tags');
	});

	app.get('/i/upload', (req, res) => {
		render(req, res, 'i/upload');
	});

	app.get('/i/settings', (req, res) =>
		render(req, res, 'i/settings'));

	app.get('/i/home-customize', (req, res) =>
		render(req, res, 'i/home-customize'));

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
			res.sendStatus(200);
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
	// SEARCH

	const searchDomain = `/subdomain/${config.domains.search}`;

	app.get(`${searchDomain}/`, (req, res) => {
		if (req.query.hasOwnProperty('q')) {
			render(req, res, 'search/result');
		} else {
			render(req, res, 'search/index');
		}
	});

	//////////////////////////////////////////////////
	// ABOUT

	const aboutDomain = `/subdomain/${config.domains.about}`;

	app.get(`${aboutDomain}/`, (req, res) => {
		render(req, res, 'about');
	});

	app.get(`${aboutDomain}/license`, (req, res) => {
		render(req, res, 'about/license');
	});

	app.get(`${aboutDomain}/technologies`, (req, res) => {
		render(req, res, 'about/technologies');
	});

	//////////////////////////////////////////////////
	// TALK

	const talkDomain = `/subdomain/${config.domains.talk}`;

	app.get(`${talkDomain}/*`, (req, res, next) => {
		if (req.headers.hasOwnProperty('referer')) {
			const referer = req.headers['referer'];
			if ((new RegExp(`^https?://(.+\.)?${config.host}/?\$`)).test(referer)) {
				res.header('X-Frame-Options', '');
			} else {
				res.header('X-Frame-Options', 'DENY');
			}
		} else {
			res.header('X-Frame-Options', 'DENY');
		}

		next();
	});

	app.get(`${talkDomain}/`, (req, res) => {
		render(req, res, 'i/talks');
	});

	app.get(`${talkDomain}/i/users`, (req, res) => {
		render(req, res, 'i/talks/users');
	});

	app.get(`${talkDomain}/i/groups`, (req, res) => {
		render(req, res, 'i/talks/groups');
	});

	app.get(`${talkDomain}/i/group/create`, (req, res) => {
		render(req, res, 'i/talks/group/create');
	});

	app.get(`${talkDomain}/:userScreenName`, (req, res) => {
		render(req, res, 'i/talk/user');
	});

	app.get(`${talkDomain}/\:group/:talkGroupId`,
		(req, res) => {
		render(req, res, 'i/talk/group');
	});

	app.get('/:userScreenName', (req, res) => {
		render(req, res, 'user/home');
	});

	app.get('/:userScreenName/following', (req, res) => {
		render(req, res, 'user/following');
	});

	app.get('/:userScreenName/followers', (req, res) => {
		render(req, res, 'user/followers');
	});

	app.get('/:userScreenName/:postId', (req, res) => {
		render(req, res, 'post');
	});

	//////////////////////////////////////////////////
	// API

	app.post('/account/create', require('./endpoints/account/create').default);
	app.post('/web/url/analyze', require('./endpoints/url/analyze').default);
	app.post('/web/avatar/update', require('./endpoints/avatar/update').default);
	app.post('/web/banner/update', require('./endpoints/banner/update').default);
	app.post('/web/home/update', require('./endpoints/home/update').default);
	app.post('/web/display-image-quality/update', require('./endpoints/display-image-quality/update').default);
	app.post('/web/pseudo-push-notification-display-duration/update',
		require('./endpoints/pseudo-push-notification-display-duration/update').default);
	app.post('/web/mobile-header-overlay/update', require('./endpoints/mobile-header-overlay/update').default);
	app.post('/web/user-settings/update', require('./endpoints/user-settings/update').default);
	app.post('/web/album/upload',
		upload.single('file'),
		require('./endpoints/album/upload').default);
	app.post('/web/posts/create-with-file',
		upload.single('file'),
		require('./endpoints/posts/create-with-file').default);
	app.post('/web/posts/reply', require('./endpoints/posts/reply').default);

	// Not found handling
	app.use((req, res) => {
		res.status(404);
		render(req, res, 'not-found');
	});

	// Error handlings

	app.use((err: any, req: express.Request, res: express.Response, next: any) => {
		if (err.code !== 'EBADCSRFTOKEN') {
			return next(err);
		}

		// handle CSRF token errors
		res.status(403).send('form tampered with');
	});

	app.use((err: any, req: express.Request, res: express.Response, next: any) => {
		console.error(err);
		//render(req, res, 'error', err);
		res.render(`${__dirname}/web/error`, {
			error: err
		});
	});
}

function paramUsername(
	req: express.Request,
	res: express.Response,
	next: () => void,
	screenName: string
): void {

	api('users/show', {
		'screen-name': screenName
	}, res.locals.signin ? res.locals.user : null).then((user: User) => {
		if (user !== null) {
			res.locals.user = user;
			next();
		} else {
			res.status(404);
			render(req, res, 'user-not-found');
		}
	}, err => {
		if (err.body === 'not-found') {
			res.status(404);
			render(req, res, 'user-not-found');
		}
	});
}

function paramPostId(
	req: express.Request,
	res: express.Response,
	next: () => void,
	postId: string
): void {

	api('posts/show', {
		'post-id': postId
	}, res.locals.signin ? res.locals.user : null).then((post: Object) => {
		if (post !== null) {
			res.locals.post = post;
			next();
		} else {
			res.status(404);
			render(req, res, 'post-not-found');
		}
	}, err => {
		if (err.body === 'not-found') {
			res.status(404);
			render(req, res, 'post-not-found');
		}
	});
}

function paramFileId(
	req: express.Request,
	res: express.Response,
	next: () => void,
	fileId: string
): void {

	api('album/files/show', {
		'file-id': fileId
	}, res.locals.signin ? res.locals.user : null).then((file: Object) => {
		res.locals.file = file;
		next();
	}, err => {
		if (err.body === 'not-found') {
			res.status(404);
			render(req, res, 'i/album/file-not-found');
		}
	});
}

function paramFolderId(
	req: express.Request,
	res: express.Response,
	next: () => void,
	folderId: string
): void {

	api('album/folders/show', {
		'folder-id': folderId
	}, res.locals.signin ? res.locals.user : null).then((folder: Object) => {
		res.locals.folder = folder;
		next();
	}, err => {
		if (err.body === 'not-found') {
			res.status(404);
			render(req, res, 'i/album/folder-not-found');
		}
	});
}

function paramTalkGroupId(
	req: express.Request,
	res: express.Response,
	next: () => void,
	groupId: string
): void {

	api('talks/group/show', {
		'group-id': groupId
	}, res.locals.user).then((group: Object) => {
		res.locals.talkGroup = group;
		next();
	}, err => {
		res.sendStatus(500);
	});
}
