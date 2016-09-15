import * as url from 'url';
import * as express from 'express';
import * as request from 'request';
import config from '../config';

export default function (req: express.Request, res: express.Response): void {
	const _url: string = req.params.url;

	request({
		_url + url.parse(_url, true).query,
		encoding: null
	}, (err, response, content) => {
		if (err) {
			console.error(err);
			return;
		}

		const contentType = response.headers['content-type'];

		if (/^text\//.test(contentType) || contentType === 'application/javascript') {
			content = content.toString().replace(/http:\/\//g, `${config.url}/_/proxy/http://`);
		}

		res.header('Content-Type', contentType);
		res.send(content);
	});
}
