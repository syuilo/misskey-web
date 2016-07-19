import * as express from 'express';
import api from '../../../core/api';

export default function (req: express.Request, res: express.Response): void {
	api('posts/reply', {
		'in-reply-to-post-id': req.body['in-reply-to-post-id'],
		'text': req.body['text'],
		'files': req.body['files']
	}, res.locals.user).then((reply: Object) => {
		res.send(reply);
	}, (err: any) => {
		res.send(err);
	});
};
