riot = require \riot

activate = require '../common/scripts/i.ls'

module.exports = (me) ~>
	iupdate = activate me

	if me?
		(require './scripts/stream.ls') me, iupdate

	(require './scripts/core.ls') me

	require './scripts/ui.ls'

	require './scripts/window.ls'
