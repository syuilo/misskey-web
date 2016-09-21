# Stream
#================================

stream = require '../stream.ls'
riot = require 'riot'

function init
	s = stream!

	s.event.on \drive_file_created (file) ~>
		n = new Notification 'ファイルがアップロードされました' do
			body: file.name
			icon: file.url + '?thumbnail&size=64'
		set-timeout (n.close.bind n), 5000ms

	riot.mixin \stream do
		stream: s.event
		stream-state: s.state

# Export
#--------------------------------

module.exports = ~> init!
