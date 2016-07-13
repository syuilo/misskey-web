import * as request from 'request';

import config from '../config';

export default async (
	endpoint: string,
	params: any,
	user: any = null,
	withFile: boolean = false
) => new Promise<any>((resolve, reject) => {
	const userId: string = user !== null
		? typeof user === 'string'
			? user
			: user.id
		: null;

	const options: request.Options = {
		url: `http://${config.api.host}:${config.api.port}/${endpoint}`,
		method: 'POST',
		headers: {
			'pass': config.api.pass,
			'user': userId
		}
	};

	if (withFile) {
		options.formData = params;
	} else {
		options.form = params;
	}

	request(options, (err, response, body) => {
		if (err !== null) {
			console.error(err);
			reject(err);
		} else if (response.statusCode !== 200) {
			reject({
				statusCode: response.statusCode,
				body: JSON.parse(body).error
			});
		} else if (body === undefined) {
			reject('something-happened');
		} else {
			const parsed = JSON.parse(body);
			resolve(parsed);
		}
	});
});
