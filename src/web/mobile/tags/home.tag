mk-home
	mk-home-timeline(event={ tl-event })

style.
	display block

script.
	@event = @opts.event

	@tl-event = riot.observable!

	@tl-event.on \loaded ~>
		@event.trigger \loaded
