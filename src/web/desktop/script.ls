load = require '../base.ls'
require 'velocity'
require 'fuck-adblock'
ReconnectingWebSocket = require 'reconnecting-websocket'
riot = require 'riot'
require './tags.ls'
route = require './router.ls'

################

if fuck-ad-block == undefined
	ad-block-detected!
else
	fuck-ad-block.on-detected ad-block-detected

function ad-block-detected
	dialog do
		'<i class="fa fa-exclamation-triangle"></i>広告ブロッカーを無効にしてください'
		'<strong>Misskeyは広告を掲載していません</strong>が、広告をブロックする機能が有効だと一部の機能が利用できなかったり、不具合が発生する場合があります。'
		[
			text: \OK
		]

################

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

load ~>
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

	riot.mount \mk-ui

	route!

# ブラウザが通知をサポートしているか確認
if \Notification in window
	# 許可を得ていない場合は許可を得る
	if Notification.permission == \default
		Notification.request-permission!
