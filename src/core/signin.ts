import * as express from 'express';
import api from '../core/api';
import config from '../config';

export default async function (username: string, password: string, res: express.Response): Promise<void> {
	const user = await api('signin', {
		username: username,
		password: password
	});

	const expires = 1000 * 60 * 60 * 24 * 365; // One Year
	res.cookie('i', user._web, {
		path: '/',
		domain: `.${config.host}`,
		secure: config.https.enable,
		httpOnly: true,
		expires: new Date(Date.now() + expires),
		maxAge: expires
	});

	res.sendStatus(204);
};
