document.domain = CONFIG.host

# ↓ iOS待ちPolyfill (SEE: http://caniuse.com/#feat=fetch)
require 'fetch'

api = require './common/scripts/api.ls'
get-post-summary = require './common/scripts/get-post-summary.ls'
riot = require 'riot'
require './common/tags/core-error.tag'

riot.mixin \get-post-summary do
	get-post-summary: get-post-summary

i = ((document.cookie.match /i=([a-zA-Z0-9]+)/) || [null, null]).1

window.SIGNIN = i?

window.api = api

module.exports = (cb) ->
	if window.SIGNIN
		fetch "#{CONFIG.api.url}/i" do
			method: \POST
			headers:
				'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
			body: "_i=#i"
		.then (res) ->
			clear-init!
			if res.status != 200
				alert 'ユーザー認証に失敗しました。ログアウトします。'
				location.href = CONFIG.urls.signout
			else
				res.json!.then (_i) ->
					_i._web = i
					window.I = _i
					if cb?
						cb!
		.catch ~>
			clear-init!
			riot.mount document.body.append-child document.create-element \mk-core-error
	else
		clear-init!
		if cb?
			cb!

function clear-init
	init = document.get-element-by-id \initializing
	init.parent-node.remove-child init
