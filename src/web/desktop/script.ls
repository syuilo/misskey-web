boot = require '../base.ls'
require 'velocity'
riot = require 'riot'
require './tags.ls'
stream = require './scripts/stream.ls'
route = require './router.ls'
fuck-ad-block = require './scripts/fuck-ad-block.ls'
dialog = require './scripts/dialog.ls'
require './scripts/user-preview.ls'

fuck-ad-block!

window.NotImplementedException = ~>
	dialog do
		'<i class="fa fa-exclamation-triangle"></i>Not implemented yet'
		'要求された操作は実装されていません。<br>→<a href="https://github.com/syuilo/misskey-web" target="_blank">Misskeyの開発に参加する</a>'
		[
			text: \OK
		]

riot.mixin \dialog do
	dialog: dialog

riot.mixin \input-dialog do
	input-dialog: require './scripts/input-dialog.ls'

riot.mixin \update-avatar do
	update-avatar: require './scripts/update-avatar.ls'

riot.mixin \update-banner do
	update-banner: require './scripts/update-banner.ls'

riot.mixin \autocomplete do
	Autocomplete: require './scripts/autocomplete.ls'

riot.mixin \cropper do
	Cropper: require 'cropper'

boot ~>
	if SIGNIN
		stream!

	route!

# ブラウザが通知をサポートしているか確認
if \Notification in window
	# 許可を得ていない場合は許可を得る
	if Notification.permission == \default
		Notification.request-permission!
