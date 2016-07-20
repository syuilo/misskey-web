import * as request from 'request';

import config from '../config';

export default (
	endpoint: string,
	params: any = {},
	user: any = null,
	withFile: boolean = false
) => new Promise<any>(async (resolve, reject) => {
	const userId: string = user !== null
		? typeof user === 'string'
			? user
			: user.id
		: undefined;

	const options: request.Options = {
		url: `http://${config.api.host}:${config.api.port}/${endpoint}`,
		method: 'POST'
	};

	params._web = config.api.pass;
	params._user = userId;

	if (withFile) {
		options.formData = params;
	} else {
		options.form = params;
	}

	request(options, (err, response, body) => {
		if (err) {
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
