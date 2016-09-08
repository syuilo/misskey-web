require '../base.ls'
require 'velocity'
ReconnectingWebSocket = require 'reconnecting-websocket'

riot = require 'riot'
require './tags/contextmenu.tag'
require './tags/dialog.tag'
require './tags/window.tag'
require './tags/input-dialog.tag'
require './tags/follow-button.tag'
require './tags/uploader.tag'
require './tags/drive/base-contextmenu.tag'
require './tags/drive/file-contextmenu.tag'
require './tags/drive/folder-contextmenu.tag'
require './tags/drive/file.tag'
require './tags/drive/folder.tag'
require './tags/drive/nav-folder.tag'
require './tags/drive/browser-window.tag'
require './tags/drive/browser.tag'
require './tags/select-file-from-drive-window.tag'
require './tags/crop-window.tag'
require './tags/settings.tag'
require './tags/settings-window.tag'
require './tags/post.tag'
require './tags/analog-clock.tag'
require './tags/go-top.tag'
require './tags/ui-header.tag'
require './tags/header-account.tag'
require './tags/header-notifications.tag'
require './tags/header-clock.tag'
require './tags/header-nav.tag'
require './tags/header-post-button.tag'
require './tags/header-search.tag'
require './tags/notifications.tag'
require './tags/post-form-window.tag'
require './tags/post-form.tag'
require './tags/post.tag'
require './tags/post-preview.tag'
require './tags/repost-form-window.tag'
require './tags/home-widgets/user-recommendation.tag'
require './tags/home-widgets/timeline.tag'
require './tags/home-widgets/calendar.tag'
require './tags/home-widgets/donate.tag'
require './tags/home-widgets/tip.tag'
require './tags/home-widgets/nav.tag'
require './tags/home-widgets/profile.tag'
require './tags/home-widgets/notifications.tag'
require './tags/home-widgets/rss-reader.tag'
require './tags/home-widgets/photo-stream.tag'
require './tags/home-widgets/broadcast.tag'
require './tags/stream-indicator.tag'
require './tags/timeline.tag'
require './tags/talk/window.tag'
require './tags/talk/room.tag'
require './tags/talk/room-window.tag'
require './tags/talk/message.tag'
require './tags/talk/index.tag'
require './tags/time.tag'
require './tags/following-setuper.tag'
require './tags/ui.tag'

dialog = (title, text, buttons, can-through, on-through) ~>
	dialog = document.body.append-child document.create-element \mk-dialog
	controller = riot.observable!
	riot.mount dialog, do
		controller: controller
		title: title
		text: text
		buttons: buttons
		can-through: can-through
		on-through: on-through
	controller.trigger \open
	return controller

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
	input-dialog: (title, placeholder, default-value, on-ok, on-cancel) ~>
		dialog = document.body.append-child document.create-element \mk-input-dialog
		riot.mount dialog, do
			title: title
			placeholder: placeholder
			default: default-value
			on-ok: on-ok
			on-cancel: on-cancel

riot.mixin \cropper do
	Cropper: require 'cropper'

state = riot.observable!
event = riot.observable!

socket = new ReconnectingWebSocket CONFIG.api.url.replace \http \ws

socket.onopen = ~>
	state.trigger \connected
	socket.send JSON.stringify do
		i: I._web

socket.onclose = ~>
	state.trigger \closed

socket.onmessage = (message) ~>
	try
		message = JSON.parse message.data
		if message.type?
			event.trigger message.type, message.body
	catch
		# ignore

event.on \drive_file_created (file) ~>
	n = new Notification 'ファイルがアップロードされました' do
		body: file.name
		icon: file.url + '?thumbnail&size=64'
	set-timeout (n.close.bind n), 5000ms

riot.mixin \stream do
	stream: event
	stream-state: state

riot.mount 'mk-ui'

# ブラウザが通知をサポートしているか確認
if \Notification in window
	# 許可を得ていない場合は許可を得る
	if Notification.permission == \default
		Notification.request-permission!
