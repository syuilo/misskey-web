riot = require \riot

activate = require '../common/scripts/i.ls'

module.exports = (me) ~>
	iupdate = activate me

	if me?
		(require './scripts/stream.ls') me, iupdate

	require './scripts/ui.ls'

	riot.mixin \open-post-form do
		open-post-form: (opts) ->
			app = document.get-element-by-id \app
			app.style.display = \none
			form = document.body.append-child document.create-element \mk-post-form
			form = riot.mount form, opts .0
			form.on \cancel recover
			form.on \post recover

			function recover
				app.style.display = \block
