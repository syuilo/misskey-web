mk-drive-page
	mk-ui: mk-drive(event={ event })

style.
	display block

script.
	@mixin \ui
	@mixin \ui-progress

	@event = riot.observable!

	@on \mount ~>
		document.title = 'Misskey Drive'
		@ui.trigger \title '<i class="fa fa-cloud"></i>ドライブ'
		@ui.trigger \bg '#fff'

	@event.on \begin-load ~>
		@Progress.start!

	@event.on \loaded-mid ~>
		@Progress.set 0.5

	@event.on \loaded ~>
		@Progress.done!
