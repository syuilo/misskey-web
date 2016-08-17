require '../../base.ls'

riot = require 'riot'
require '../../tags/contextmenu.tag'
require '../../tags/window.tag'
require '../../tags/input-dialog.tag'
require '../../tags/follow-button.tag'
require '../../tags/uploader.tag'
require '../../tags/drive-browser-base-contextmenu.tag'
require '../../tags/drive-browser-file-contextmenu.tag'
require '../../tags/drive-browser.tag'
require '../../tags/select-file-from-drive-window.tag'
require '../../tags/post.tag'
require '../../tags/analog-clock.tag'
require '../../tags/go-top.tag'
require '../../tags/header.tag'
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
tl = require '../../tags/timeline.tag'
ui = require '../../tags/ui.tag'

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

socket = io CONFIG.api.url, do
	transports: [\websocket]

socket.on \connect ->
	console.log \connected
	socket.emit \authentication do
		_i: USER._web

socket.on \unauthorized ->
	console.log \unauthorized

socket.on \authenticated ->
	console.log \authenticated

socket.on \disconnect ->
	console.log \disconnect

socket.on \post (post) ->
	console.log post
	tl.opts.posts.unshift post
	tl.update!
