mk-home-page
	mk-ui: mk-home(event={ event })

style.
	display block

script.
	@mixin \ui-progress

	@event = riot.observable!

	@on \mount ~>
		@Progress.start!

		document.title = 'Misskey'

	@event.on \loaded ~>
		@Progress.done!
