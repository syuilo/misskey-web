# ↓ iOS待ちPolyfill (SEE: http://caniuse.com/#feat=fetch)
require 'fetch'

riot = require 'riot'

document.domain = CONFIG.host

i = ((document.cookie.match /i=([a-zA-Z0-9]+)/) || [null, null]).1

window.SIGNIN = i?

module.exports = (cb) ->
	if window.SIGNIN
		fetch "#{CONFIG.api.url}/i" do
			method: \POST
			headers:
				'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
			body: "_i=#i"
		.then (res) ->
			res.json!.then (_i) ->
				_i._web = i
				window.I = _i
				init = document.get-element-by-id \initializing
				init.parent-node.remove-child init
				if cb?
					cb!
	else
		init = document.get-element-by-id \initializing
		init.parent-node.remove-child init
		if cb?
			cb!

get-post-summary = (post) ~>
	summary = if post.text? then post.text else ''
	if post.images?
		summary += " (#{post.images.length}枚の画像)"
	if post.reply_to?
		if typeof post.reply_to == \string
			summary += " RE: ..."
		else
			reply-summary = get-post-summary post.reply_to
			summary += " RE: #{reply-summary}"
	if post.repost?
		if typeof post.reply_to == \string
			summary = summary + " RP: ..."
		else
			repost-summary = get-post-summary post.repost
			summary = summary + " RP: #{repost-summary}"
	return summary.trim!

riot.mixin \get-post-summary do
	get-post-summary: get-post-summary

window.api = (endpoint, data) ->
	body = []

	for k, v of data
		if v != undefined
			v = encodeURIComponent v
			body.push "#k=#v"

	if SIGNIN
		body.push "_i=#{I._web}"

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
		fetch ep, opts
		.then (res) ->
			if res.status == 200
				res.json!
			else if res.status == 204
				resolve!
			else
				res.json!.then (err) ->
					reject err.error
		.then (data) ->
			resolve data
		.catch (e) ->
			reject e
