expires = 3600000ms

function set type, value
	if SIGNIN and !I.data.cache
		return
	key = "cache-#{type}-#{value.id}"
	value.__cached_at = Date.now!
	local-storage.set-item key, JSON.stringify value

function get type, id
	if SIGNIN and !I.data.cache
		return null
	key = "cache-#{type}-#{id}"
	value = JSON.parse local-storage.get-item key
	if value?
		now = Date.now!
		if now - value.__cached_at > expires
			local-storage.remove-item key
			null
		else
			delete value.__cached_at
			value
	else
		null

module.exports =
	set: set
	get: get
