# AUTH FORM SCRIPT
#================================

riot = require \riot

document.title = 'Misskey | アプリの連携'

# Define tags
#--------------------------------

require './tags.ls'

# Boot
#--------------------------------

boot = require '../boot.ls'

boot (me) ~>
	# mount
	mount document.create-element \mk-index

# Mount
#================================

function mount content
	body = document.get-element-by-id \app
	riot.mount body.append-child content .0
