import api from '../core/request-api';
import { UserSettings } from '../db/models/user-settings';

export default (username: string, password: string, session: any) => new Promise<void>(async (resove, reject) => {
	const user = await api('signin', {
		'username': username,
		'password': password
	});

	// ユーザー設定引き出し
	const settings = await UserSettings.findOne({
		userId: user.id
	});

	if (settings === null) {
		// ユーザー設定が無ければ作成
		UserSettings.create({
			userId: user.id
		}, (createErr, created) => {
			saveSession(user);
		});
	} else {
		saveSession(user);
	}

	function saveSession(user: any): void {
		session.userId = user.id;
		session.save(() => {
			resove();
		});
	}
});
