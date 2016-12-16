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

riot = require \riot
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

# Check for Update
check-for-update!

# Get token from cookie
i = ((document.cookie.match /i=(\w+)/) || [null null]).1

if i? then log "ME: #{i}"

module.exports = (callback) ~>
	# Get cached account data
	cached-me = JSON.parse local-storage.get-item \me

	if cached-me?.data?.cache
		fetched cached-me

		# 後から新鮮なデータをフェッチ
		fetchme i, true, (fresh-data) ~>
			Object.assign cached-me, fresh-data
			cached-me.trigger \updated
	else
		# キャッシュ無効なのにキャッシュが残ってたら掃除
		if cached-me?
			local-storage.remove-item \me

		fetchme i, false, fetched

	function fetched me

		if me?
			riot.observable me

			if me.data.cache
				local-storage.set-item \me JSON.stringify me

				me.on \updated ~>
					# キャッシュ更新
					local-storage.set-item \me JSON.stringify me

			log "Fetched! Hello #{me.username}."

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
