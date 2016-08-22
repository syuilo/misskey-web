require '../base.ls'
riot = require 'riot'
require 'velocity'
ReconnectingWebSocket = require 'reconnecting-websocket'

riot.mixin \dialog do
	dialog: (title, text, buttons, can-through, on-through) ~>
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

# ブラウザが通知をサポートしているか確認
if \Notification in window
	# 許可を得ていない場合は許可を得る
	if Notification.permission == \default
		Notification.request-permission!

state = riot.observable!
event = riot.observable!

socket = new ReconnectingWebSocket CONFIG.api.url.replace \http \ws

socket.onopen = ~>
	state.trigger \connected
	socket.send JSON.stringify do
		i: USER._web

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
