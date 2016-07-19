import * as express from 'express';
import UserSetting from '../../../db/models/user-settings';

export default function (req: express.Request, res: express.Response): void {
	const layoutString: string = req.body['layout'];
	const layout = JSON.parse(layoutString);

	const saveLayout: any = {
		left: [],
		center: [],
		right: []
	};

	if (layout.left !== undefined) {
		saveLayout.left = layout.left;
	}
	if (layout.center !== undefined) {
		saveLayout.center = layout.center;
	}
	if (layout.right !== undefined) {
		saveLayout.right = layout.right;
	}

	UserSetting.findOne({
		userId: res.locals.user
	}, (findErr, settings) => {
		if (findErr !== null) {
			res.sendStatus(500);
			return;
		}
		settings.homeLayout = saveLayout;
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
