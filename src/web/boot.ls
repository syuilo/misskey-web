#================================
# Boot loader
#================================

riot = require 'riot'
api = require './common/scripts/api.ls'
generate-default-userdata = require './common/scripts/generate-default-userdata.ls'

i = window._I

boot = (cb) ~>
	if not window.SIGNIN
		return done!

	# ユーザー情報フェッチ
	fetch "#{CONFIG.api.url}/i" do
		method: \POST
		headers:
			'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
		body: "_i=#i"
	.then (res) ~>
		if res.status != 200
			alert 'ユーザー認証に失敗しました。ログアウトします。'
			location.href = CONFIG.urls.signout
			return

		_i <~ res.json!.then
		_i._web = i
		window.I = _i

		if I.data?
			done!
		else
			init!
	.catch (e) ~>
		console.error e
		info = document.create-element \mk-core-error
			|> document.body.append-child
		riot.mount info, do
			refresh: ~> boot cb

	function done
		init = document.get-element-by-id \init
		init.parent-node.remove-child init

		document.create-element \div
			..set-attribute \id \kyoppie
			.. |> document.body.append-child

		if cb? then cb!

	function init
		data = generate-default-userdata!

		api \i/appdata/set do
			data: JSON.stringify data
		.then ~>
			I.data = data
			done!

module.exports = boot
