import {Schema, Document} from 'mongoose';
import db from '../db';

const schema: any = {
	displayImageQuality:                         { type: Number, required: false, default: 90 },
	pseudoPushNotificationDisplayDuration:       { type: Number, required: false, default: 5000 },
	enableSushi:                                 { type: Boolean, required: false, default: false },
	displayUserNameInPost:                       { type: Boolean, required: false, default: true },
	displayUserScreenNameInPost:                 { type: Boolean, required: false, default: false },
	displayCreatedAtInPost:                      { type: Boolean, required: false, default: true },
	displayActionsInPost:                        { type: Boolean, required: false, default: true },
	confirmationWhenRepost:                      { type: Boolean, required: false, default: true },
	enableUrlPreviewInPost:                      { type: Boolean, required: false, default: true },
	thumbnailyzeAttachedImageOfPost:             { type: Boolean, required: false, default: false },
	enableNotificationSoundWhenReceivingNewPost: { type: Boolean, required: false, default: true },
	readTimelineAutomatically:                   { type: Boolean, required: false, default: true },
	theme:                                       { type: String, required: false, default: null },
	home:                                        { type: Schema.Types.Mixed, required: false, default: {
		left: [],
		center: ['timeline'],
		right: ['my-status', 'notifications', 'recommendation-users', 'donate', 'ad']
	}},
	mobileHeaderOverlay:                         { type: String, required: false, default: null },
	userId:                                      { type: Schema.Types.ObjectId, required: true }
};

export default db.model<IUserSettings>('UserSetting', new Schema(schema), 'user_settings');

export interface IUserSettings extends Document {
	displayImageQuality: number;
	pseudoPushNotificationDisplayDuration: number;
	uiLanguage: string;
	theme: string;
	homeLayout: any;
	mobileHeaderOverlay: string;
	userId: string;
}

let guestUserSettings0: any = {};

for (let key in schema) {
	if (schema.hasOwnProperty(key)) {
		const value: any = schema[key];
		if (!value.required) {
			guestUserSettings0[key] = value.default;
		}
	}
}

export const guestUserSettings = guestUserSettings0;
