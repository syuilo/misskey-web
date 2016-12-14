# BASE SCRIPT
#================================

# for subdomains
document.domain = CONFIG.host

# ↓ iOS待ちPolyfill (SEE: http://caniuse.com/#feat=fetch)
require \fetch

# ↓ NodeList、HTMLCollectionで forEach を使えるようにする
if NodeList.prototype.for-each == undefined
	NodeList.prototype.for-each = Array.prototype.for-each
if HTMLCollection.prototype.for-each == undefined
	HTMLCollection.prototype.for-each = Array.prototype.for-each

# Load common dependencies
#--------------------------------

require \velocity

# Define common tags
#--------------------------------

require './common/tags.ls'

# Boot
#--------------------------------

log = require './common/scripts/log.ls'

fetchme = require './fetchme.ls'
mixins = require './mixins.ls'
panic = require './panic.ls'
check-for-update = require './common/scripts/check-for-update.ls'

log "Misskey (aoi) v:#{VERSION}"

# Get token from cookie
i = ((document.cookie.match /i=(\w+)/) || [null null]).1

if i? then log "ME: #{i}"

module.exports = (callback) ~>
	# fetch me
	me <~ fetchme i

	if me? then log "Fetched! Hello #{me.username}."

	# activate mixins
	mixins me

	# destroy loading screen
	init = document.get-element-by-id \init
	init.parent-node.remove-child init

	# set main element
	document.create-element \div
		..set-attribute \id \app
		.. |> document.body.append-child

	# Call main proccess
	try
		callback me
	catch error
		panic error

	# Check for Update
	check-for-update!
