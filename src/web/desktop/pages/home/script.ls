require '../../base.ls'

riot = require 'riot'
require '../../tags/contextmenu.tag'
require '../../tags/dialog.tag'
require '../../tags/window.tag'
require '../../tags/input-dialog.tag'
require '../../tags/follow-button.tag'
require '../../tags/uploader.tag'
require '../../tags/drive-browser-base-contextmenu.tag'
require '../../tags/drive-browser-file-contextmenu.tag'
require '../../tags/drive-browser-folder-contextmenu.tag'
require '../../tags/drive-browser-file.tag'
require '../../tags/drive-browser-folder.tag'
require '../../tags/drive-browser-nav-folder.tag'
require '../../tags/drive-browser-window.tag'
require '../../tags/drive-browser.tag'
require '../../tags/select-file-from-drive-window.tag'
require '../../tags/crop-window.tag'
require '../../tags/settings.tag'
require '../../tags/settings-window.tag'
require '../../tags/post.tag'
require '../../tags/analog-clock.tag'
require '../../tags/go-top.tag'
require '../../tags/ui-header.tag'
require '../../tags/header-account.tag'
require '../../tags/header-clock.tag'
require '../../tags/header-nav.tag'
require '../../tags/header-post-button.tag'
require '../../tags/header-search.tag'
require '../../tags/post-form-window.tag'
require '../../tags/post-form.tag'
require '../../tags/post.tag'
require '../../tags/post-preview.tag'
require '../../tags/repost-form-window.tag'
require '../../tags/home-widgets/user-recommendation.tag'
require '../../tags/home-widgets/timeline.tag'
require '../../tags/home-widgets/calendar.tag'
require '../../tags/home-widgets/donate.tag'
require '../../tags/stream-indicator.tag'
tl = require '../../tags/timeline.tag'
ui = require '../../tags/ui.tag'

socket = new WebSocket CONFIG.api.url.replace \http \ws

socket.add-event-listener \open ~>
	socket.send JSON.stringify do
		i: USER._web

socket._listeners = {}
socket.on = (ev, fn) ~>
	_fn = (message) ~>
		message = JSON.parse message.data
		if message.type? and message.type == ev
			fn message.body
	if !(ev in socket._listeners)
		socket._listeners[ev] = []
	socket._listeners[ev].push _fn
	socket.add-event-listener \message _fn
socket.off = (ev, fn) ~>
	listeners = socket._listeners[ev]
	listeners.for-each (listener, i) ~>
		if listener == fn
			stack.splice i, 1
			socket.remove-event-listener \message listener

riot.mixin \stream do
	stream: socket

riot.mount ui

tl = (riot.mount tl).0

api 'posts/timeline'
	.then (posts) ->
		tl.update opts: posts: posts
	.catch (err, text-status) ->
		console.error err

is-active = yes
unread-count = 0

try
	Notification.request-permission!
catch
	console.log 'oops'

socket.on \post (post) ->
	console.log post
	tl.opts.posts.unshift post
	tl.update!
