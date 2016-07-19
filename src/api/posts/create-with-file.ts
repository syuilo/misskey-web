import * as fs from 'fs';
import * as express from 'express';
import api from '../../core/api';

export default function (req: express.Request, res: express.Response): void {
	const file: Express.Multer.File = (<any>req).file;
	if (file !== undefined && file !== null) {
		const data: any = {};
		data.file = {
			value: fs.readFileSync(file.path),
			options: {
				filename: file.originalname,
				contentType: file.mimetype
			}
		};
		fs.unlink(file.path);
		api('album/files/upload', data, res.locals.user, true).then((albumFile: Object) => {
			create(albumFile);
		}, (err: any) => {
			console.error(err);
			res.status(500).send(err);
		});
	} else {
		create();
	}

	function create(fileEntity: any = null): void {
		const inReplyToPostId = req.body['in-reply-to-post-id'];
		if (inReplyToPostId !== undefined && inReplyToPostId !== null && inReplyToPostId !== '') {
			api('posts/reply', {
				'text': req.body.text,
				'files': fileEntity !== null ? fileEntity.id : null,
				'in-reply-to-post-id': inReplyToPostId
			}, res.locals.user).then((post: Object) => {
				res.send(post);
			}, (err: any) => {
				res.status(500).send(err);
			});
		} else {
			api('posts/create', {
				'text': req.body.text,
				'files': fileEntity !== null ? fileEntity.id : null
			}, res.locals.user).then((post: Object) => {
				res.send(post);
			}, (err: any) => {
				res.status(500).send(err);
			});
		}
	}
};
