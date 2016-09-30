cache = require './cache.ls'

module.exports = (data) ~>
	scan data

function scan data
	extract data
	keys = Object.keys data
	keys.for-each (key) ~>
		if data[key]? and typeof data[key] == \object
			scan data[key]

function extract data
	if is-user data
		cache.set \user data

function is-user data
	data.has-own-property \id and
	data.has-own-property \username
