import * as express from 'express';
import UserSetting from '../../db/models/user-settings';

export default function (req: express.Request, res: express.Response): void {
	const duration: string = req.body['duration'];

	UserSetting.findOne({
		userId: res.locals.user
	}, (findErr, settings) => {
		if (findErr !== null) {
			res.sendStatus(500);
			return;
		}
		settings.pseudoPushNotificationDisplayDuration = Number(duration);
		settings.save((saveErr, savedSettings) => {
			if (saveErr !== null) {
				res.sendStatus(500);
				return;
			}
			req.session.save(() => {
				res.sendStatus(200);
			});
		});
	});
};
