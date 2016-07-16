window.$ = require 'jquery'
Cookies = require 'js-cookie'

u = Cookies.get \u

if u?
	user = JSON.parse u
else
	user = null

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

$.ajax-setup do
	type: \post
	cache: no
	xhr-fields: {+with-credentials}

	# ヘッダーに含めるとCORSのプリフライトが発動して余計な通信が増えるので
	#headers:
	#	'csrf-token': CSRF_TOKEN

	data: { _csrf: CSRF_TOKEN }
