riot = require \riot

module.exports = (me) ~>

	(require './scripts/stream.ls') me

	(require './scripts/core.ls') me

	require './scripts/ui.ls'

	require './scripts/window.ls'

