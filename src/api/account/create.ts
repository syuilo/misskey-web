import * as express from 'express';
import * as request from 'request';
import api from '../../core/api';
import config from '../../config';

export default (req: express.Request, res: express.Response) => {
	request({
		url: 'https://www.google.com/recaptcha/api/siteverify',
		method: 'POST',
		form: {
			'secret': config.recaptcha.secretKey,
			'response': req.body['g-recaptcha-response']
		}
	}, (err, response, body) => {
		if (err) {
			console.error(err);
			res.sendStatus(500);
			return;
		}

		const parsed = JSON.parse(body);

		if (parsed.success) {
			api('signup', {
				username: req.body['username'],
				password: req.body['password']
			}).then(account => {
				res.send(account);
			}, err2 => {
				res.send(err2);
			});
		} else {
			res.status(400).send('recaptcha-failed');
		}
	});
};
