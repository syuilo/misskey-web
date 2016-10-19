# DESKTOP CLIENT SCRIPT
#================================

# Define common tags
#--------------------------------

require './tags.ls'

# Fuck AD Block
#--------------------------------

fuck-ad-block = require './scripts/fuck-ad-block.ls'
fuck-ad-block!

# Notification
#--------------------------------

# ブラウザが通知をサポートしているか確認
if \Notification in window
	# 許可を得ていない場合は許可を得る
	if Notification.permission == \default
		Notification.request-permission!

# Boot
#--------------------------------

boot = require '../base.ls'
route = require './router.ls'

boot (me) ~>
	# activate mixins
	mixins = require './mixins.ls'
	mixins me

	# routing
	route me
