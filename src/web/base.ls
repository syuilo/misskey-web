# BASE SCRIPT
#================================

# for subdomains
document.domain = CONFIG.host

# ↓ iOS待ちPolyfill (SEE: http://caniuse.com/#feat=fetch)
require \fetch

# ↓ Firefox, Edge待ちPolyfill
if NodeList.prototype.for-each == undefined
	NodeList.prototype.for-each = Array.prototype.for-each

# Load dependencies
#--------------------------------

require \velocity
require \chart.js

# Define common tags
#--------------------------------

require './common/tags.ls'

# Boot
#--------------------------------

fetchme = require './fetchme.ls'

# Get token from cookie
i = ((document.cookie.match /i=(\w+)/) || [null null]).1

module.exports = (cb) ~>
	# fetch me
	me <~ fetchme i

	# activate mixins
	mixins = require './mixins.ls'
	mixins me

	cb me
