require 'fetch'

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
