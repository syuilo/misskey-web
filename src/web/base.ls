window.$ = require 'jquery'
Cookies = require 'js-cookie'

window.CONFIG = require 'config'
window.CSRF_TOKEN = $ 'meta[name="csrf-token"]' .attr \content
window.USER = JSON.parse Cookies.get \u
window.SIGNIN = window.USER?

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
