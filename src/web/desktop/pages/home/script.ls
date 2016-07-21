require '../../base.ls'

riot = require 'riot'
require '../../tags/post.tag'
require '../../tags/analog-clock.tag'
require '../../tags/go-top.tag'
require '../../tags/header.tag'
require '../../tags/header-account.tag'
require '../../tags/header-clock.tag'
require '../../tags/header-nav.tag'
require '../../tags/header-post-button.tag'
require '../../tags/header-search.tag'
require '../../tags/post-form.tag'
require '../../tags/post.tag'
tl = require '../../tags/timeline.tag'
ui = require '../../tags/ui.tag'

riot.mount ui

api 'posts/timeline'
	.then (posts) ->
		riot.mount tl, do
			posts: posts
	.catch (err, text-status) ->
		console.error err

is-active = yes
unread-count = 0

try
	Notification.request-permission!
catch
	console.log 'oops'

socket = io CONFIG.api.url + '/'

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
