mk-user-page
	mk-ui: mk-user(user={ user }, event={ event })

style.
	display block

script.
	@mixin \ui-progress

	@user = @opts.user
	@event = riot.observable!

	@on \mount ~>
		@Progress.start!

	@event.on \loaded ~>
		@Progress.done!
