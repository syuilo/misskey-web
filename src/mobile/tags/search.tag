mk-search
	mk-search-posts(query={ query }, event={ event })

style.
	display block

script.
	@query = @opts.query
	@event = @opts.event
	@tl-event = riot.observable!

	@tl-event.on \loaded ~>
		@evemt.trigger \loaded
