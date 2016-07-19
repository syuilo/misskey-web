require 'fetch'

window.api = (endpoint, data) ->
	body = []

	for k, v of data
		body.push "#{k}=#{v}"

	fetch "#{CONFIG.api.url}/#{endpoint}" do
		method: \POST
		headers:
			'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
		body: body.join \&

Cookies = require 'js-cookie'

u = Cookies.get \u
user = if u? then JSON.parse u else null

window.CONFIG = require 'config'
window.CSRF_TOKEN = Cookies.get \x
window.USER = user
window.SIGNIN = window.USER?

Cookies.remove \x do
	path: \/
	domain: '.' + CONFIG.host

Cookies.remove \u do
	path: \/
	domain: '.' + CONFIG.host

document.domain = CONFIG.host
