api = require '../../common/scripts/api.ls'
riot = require \riot

module.exports = (me) ~>
	core = riot.observable!
	core.on \post ~>
		text = window.prompt '新規投稿'
		if text? and text != ''
			api me, \posts/create do
				text: text

	riot.mixin \core do
		core: core
