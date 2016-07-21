# require 'fetch'

window.api = (endpoint, data) ->
	body = []

	for k, v of data
		body.push "#{k}=#{v}"

	if SIGNIN
		body.push "_i=#{USER._web}"

	new Promise (resolve, reject) ->
		fetch "#{CONFIG.api.url}/#{endpoint}" do
			method: \POST
			headers:
				'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
			body: body.join \&
		.then (res) ->
			if res.status != 204
				res.json!
		.then (data) ->
			resolve data
		.catch (e) ->
			reject e

window.webapi = (endpoint, data) ->
	body = ["_csrf=#{CSRF_TOKEN}"]

	for k, v of data
		body.push "#{k}=#{v}"

	ep = if (endpoint.index-of '://') == -1
		then "#{CONFIG.url}/_/api/#{endpoint}"
		else endpoint

	new Promise (resolve, reject) ->
		fetch ep, do
			credentials: \include
			method: \POST
			headers:
				'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
			body: body.join \&
		.then (res) ->
			if res.status != 204
				res.json!
		.then (data) ->
			resolve data
		.catch (e) ->
			reject e
