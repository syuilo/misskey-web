import * as express from 'express';
import api from '../core/api';
import config from '../config';

export default async function (username: string, password: string, res: express.Response): Promise<void> {
	const ctx = await api('signin', {
		username: username,
		password: password
	});

	const expires = 1000 * 60 * 60 * 24 * 365; // One Year
	res.cookie('i', ctx.web, {
		path: '/',
		domain: `.${config.host}`,
		secure: config.https.enable,
		httpOnly: false,
		expires: new Date(Date.now() + expires),
		maxAge: expires
	});

	res.sendStatus(204);
};
