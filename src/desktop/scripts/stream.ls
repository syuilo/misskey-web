# Stream
#================================

stream = require '../../common/scripts/stream.ls'
get-post-summary = require '../../common/scripts/get-post-summary.ls'
riot = require \riot

function init me, manager
	s = stream me, manager

	s.event.on \drive_file_created (file) ~>
		n = new Notification 'ファイルがアップロードされました' do
			body: file.name
			icon: file.url + '?thumbnail&size=64'
		set-timeout (n.close.bind n), 5000ms

	s.event.on \mention (post) ~>
		title = switch
			| post.reply_to_id? => "#{post.user.name}さんから返信"
			| post.repost_id?   => "#{post.user.name}さんが引用"
			| _                 => "#{post.user.name}さんから"
		n = new Notification "#{title}:" do
			body: get-post-summary post
			icon: post.user.avatar_url + '?thumbnail&size=64'
		set-timeout (n.close.bind n), 6000ms

	riot.mixin \stream do
		stream: s.event
		get-stream-state: s.get-state
		stream-state-ev: s.state-ev

# Export
#--------------------------------

module.exports = init
