mk-home
	mk-home-timeline(event={ tl-event })

style.
	display block

	> mk-home-timeline
		max-width 500px
		margin 0 auto

script.
	@event = @opts.event

	@tl-event = riot.observable!

	@tl-event.on \loaded ~>
		@event.trigger \loaded
