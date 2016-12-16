# DEVELOPER CENTER SCRIPT
#================================

# Define tags
#--------------------------------

require './tags.ls'

# Boot
#--------------------------------

boot = require '../boot.ls'
route = require './router.ls'

boot (me) ~>
	# routing
	route me
