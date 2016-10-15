boot = require '../base.ls'
riot = require 'riot'
require './tags.ls'
stream = require './scripts/stream.ls'
route = require './router.ls'

boot ~>
	if SIGNIN
		stream!

	route!
