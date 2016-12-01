mk-home-page
	mk-ui: mk-home(mode={ parent.opts.mode }, event={ parent.event })

style.
	display block

	background-position center center
	background-attachment fixed
	background-size cover

script.
	@mixin \i
	@mixin \api
	@mixin \ui-progress
	@mixin \stream
	@mixin \get-post-summary

	@event = riot.observable!
	@unread-count = 0

	@on \mount ~>
		document.title = 'Misskey'
		if @I.data.wallpaper
			@api \drive/files/show do
				file_id: @I.data.wallpaper
			.then (file) ~>
				@root.style.background-image = 'url(' + file.url + ')'
		@Progress.start!
		@stream.on \post @on-stream-post
		document.add-event-listener \visibilitychange @window-on-visibilitychange, false

	@on \unmount ~>
		@stream.off \post @on-stream-post
		document.remove-event-listener \visibilitychange @window-on-visibilitychange

	@event.on \loaded ~>
		@Progress.done!

	@on-stream-post = (post) ~>
		if document.hidden and post.user_id !== @I.id
			@unread-count++
			document.title = '(' + @unread-count + ') ' + @get-post-summary post

	@window-on-visibilitychange = ~>
		if !document.hidden
			@unread-count = 0
			document.title = 'Misskey'
