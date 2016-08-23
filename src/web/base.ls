require 'fetch'

window.api = (endpoint, data) ->
	body = []

	for k, v of data
		if v != undefined
			v = encodeURIComponent v
			body.push "#k=#v"

	if SIGNIN
		body.push "_i=#{USER._web}"

	new Promise (resolve, reject) ->
		fetch "#{CONFIG.api.url}/#{endpoint}" do
			method: \POST
			headers:
				'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
			body: body.join \&
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
