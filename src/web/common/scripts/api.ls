riot = require \riot

spinner = null
api-stack = 0

net = riot.observable!

riot.mixin \net do
	net: net

module.exports = (i, endpoint, data) ->
	api-stack++

	if i? and typeof i == \object then i = i._web

	web = (endpoint.index-of '://') > -1

	body = []

	for k, v of data
		if v != undefined
			v = encodeURIComponent v
			body.push "#k=#v"

	if i? and not web
		body.push "_i=#i"

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

	if api-stack == 1
		spinner := document.create-element \div
			..set-attribute \id \wait
		document.body.append-child spinner

	new Promise (resolve, reject) ->
		timer = set-timeout ->
			net.trigger \detected-slow-network
		, 5000ms

		fetch ep, opts
		.then (res) ->
			api-stack--
			clear-timeout timer
			if api-stack == 0
				spinner.parent-node.remove-child spinner

			if res.status == 200
				res.json!.then resolve
			else if res.status == 204
				resolve!
			else
				res.json!.then (err) ->
					reject err.error
		.catch reject
