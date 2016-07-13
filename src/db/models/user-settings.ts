import {Schema, Document} from 'mongoose';
import db from '../db';

const schema = new Schema({
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
});

export interface IUserSettings extends Document {
	displayImageQuality: number;
	pseudoPushNotificationDisplayDuration: number;
	uiLanguage: string;
	theme: string;
	homeLayout: any;
	mobileHeaderOverlay: string;
	userId: string;
}

export default db.model<IUserSettings>('UserSetting', schema, 'user_settings');
