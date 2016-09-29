riot = require 'riot'
cache = require './cache.ls'

core = riot.observable!

riot.mixin \core do
	core: core

module.exports = (endpoint, data) ->
	body = []

	for k, v of data
		if v != undefined
			v = encodeURIComponent v
			body.push "#k=#v"

	if window.SIGNIN
		body.push "_i=#{window.I._web}"

	web = (endpoint.index-of '://') > -1

	opts =
		method: \POST
		headers:
			'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
		body: body.join \&

	if web
		ep = endpoint
		opts.credentials = \include
	else
		ep = "#{CONFIG.api.url}/#{endpoint}"

	new Promise (resolve, reject) ->
		timer = set-timeout ->
			core.trigger \detected-slow-network
		, 5000ms
		fetch ep, opts
		.then (res) ->
			clear-timeout timer
			if res.status == 200
				res.json!
			else if res.status == 204
				resolve!
			else
				res.json!.then (err) ->
					reject err.error
		.then (data) ->
			resolve data

			switch endpoint
				| \i =>
					cache.set \user data
				| \i/notifications =>
					data.for-each (notification) ~>
						if typeof notification.user == \object
							cache.set \user notification.user
				| \users/show =>
					cache.set \user data
				| \users/recommendation =>
					data.for-each (user) ~>
						cache.set \user user
				| \posts/show =>
					cache.set \user data.user
					if typeof data.reply_to == \object
						cache.set \user data.reply_to.user
				| \posts/timeline, \users/posts =>
					data.for-each (post) ~>
						cache.set \user post.user
						if typeof post.reply_to == \object
							cache.set \user post.reply_to.user
				| \posts/replies =>
					data.for-each (post) ~>
						cache.set \user post.user
				| \posts/reposts =>
					data.for-each (post) ~>
						cache.set \user post.user
				| \posts/likes =>
					data.for-each (user) ~>
						cache.set \user user

		.catch (e) ->
			reject e
