#================================
# Fetch me
#================================

riot = require \riot

api = require './common/scripts/api.ls'
generate-default-userdata = require './common/scripts/generate-default-userdata.ls'

fetchme = (token, cb) ~>
	me = null

	if not token?
		return done!

	# ユーザー情報フェッチ
	fetch "#{CONFIG.api.url}/i" do
		method: \POST
		headers:
			'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
		body: "i=#token"
	.then (res) ~>
		if res.status != 200
			alert 'ユーザー認証に失敗しました。ログアウトします。'
			location.href = '/signout!'
			return

		i <~ res.json!.then
		me := i
		me.token = token

		# initialize it if user data is empty
		if me.data?
			done!
		else
			init!
	.catch (e) ~>
		console.error e
		info = document.create-element \mk-core-error
			|> document.body.append-child
		riot.mount info, do
			retry: ~> fetchme token, cb

	function done
		if cb? then cb me

	function init
		data = generate-default-userdata!

		api token, \i/appdata/set do
			data: JSON.stringify data
		.then ~>
			me.data = data
			done!

module.exports = fetchme
