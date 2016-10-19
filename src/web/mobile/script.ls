boot = require '../base.ls'
riot = require 'riot'
require './tags.ls'
stream = require './scripts/stream.ls'
route = require './router.ls'

boot (me) ~>
	if me?
		stream me

	route me
