document.domain = CONFIG.host

# ↓ iOS待ちPolyfill (SEE: http://caniuse.com/#feat=fetch)
require 'fetch'

# ↓ Firefox, Edge待ちPolyfill
if NodeList.prototype.forEach === undefined
	NodeList.prototype.forEach = Array.prototype.forEach

window.api = require './common/scripts/api.ls'
window.is-promise = require './common/scripts/is-promise.ls'

riot = require 'riot'
require './common/tags/core-error.tag'
require './common/tags/url.tag'
require './common/tags/url-preview.tag'
require './common/tags/ripple-string.tag'
require './common/tags/kawaii.tag'

riot.mixin \get-post-summary do
	get-post-summary: require './common/scripts/get-post-summary.ls'

riot.mixin \text do
	analyze: require 'misskey-text'
	compile: require './common/scripts/text-compiler.js'

riot.mixin \get-password-strength do
	get-password-strength: require 'strength.js'

riot.mixin \ui-progress do
	Progress: require './common/scripts/loading.ls'

i = ((document.cookie.match /i=([a-zA-Z0-9]+)/) || [null, null]).1

window.SIGNIN = i?

load = (cb) ->
	if window.SIGNIN
		fetch "#{CONFIG.api.url}/i" do
			method: \POST
			headers:
				'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
			body: "_i=#i"
		.then (res) ->
			if res.status != 200
				alert 'ユーザー認証に失敗しました。ログアウトします。'
				location.href = CONFIG.urls.signout
			else
				res.json!.then (_i) ->
					_i._web = i
					window.I = _i
					done!
		.catch (e) ~>
			console.error e
			riot.mount (document.body.append-child document.create-element \mk-core-error), do
				refresh: ~> load cb
	else
		done!

	function done
		init = document.get-element-by-id \initializing
		init.parent-node.remove-child init

		document.create-element \div
			..set-attribute \id \kyoppie
			.. |> document.body.append-child

		if cb? then cb!

module.exports = load
