mk-timeline-home-widget
	mk-timeline(controller={ controller })

style.
	display block

script.
	@mixin \stream

	@unread-count = 0
	@controller = riot.observable!

	@on \mount ~>
		document.add-event-listener \visibilitychange @window-on-visibilitychange, false
		document.add-event-listener \keydown (e) ~>
			tag = e.target.tag-name.to-lower-case!
			if tag != \input and tag != \textarea
				if e.which == 84 # t
					@controller.trigger \focus

		api \posts/timeline
			.then (posts) ~>
				@controller.trigger \set-posts posts
			.catch (err) ~>
				console.error err

	@stream.on \post (post) ~>
		@controller.trigger \add-post post

		if document.hidden
			@unread-count++
			# TODO
			document.title = '(' + @unread-count + ') ' + 'hoge'

	@window-on-visibilitychange = ~>
		if !document.hidden
			@unread-count = 0
			document.title = 'Misskey'
