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
