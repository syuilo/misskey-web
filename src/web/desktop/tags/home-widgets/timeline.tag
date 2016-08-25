mk-timeline-home-widget
	p.loading(if={ is-loading })
		| 読み込み中...
	p.empty(if={ is-empty })
		| 自分の投稿や、自分がフォローしているユーザーの投稿が表示されます。
	mk-timeline(controller={ controller })

style.
	display block
	background #fff

	> p
		display block
		margin 0
		padding 16px
		text-align center
		color #999

script.
	@mixin \stream

	@is-loading = true
	@is-empty = false
	@unread-count = 0
	@controller = riot.observable!

	@on \mount ~>
		alert \mount

		document.add-event-listener \visibilitychange @window-on-visibilitychange, false
		document.add-event-listener \keydown (e) ~>
			tag = e.target.tag-name.to-lower-case!
			if tag != \input and tag != \textarea
				if e.which == 84 # t
					@controller.trigger \focus

		api \posts/timeline
			.then (posts) ~>
				@is-loading = false
				if posts.length == 0
					@is-empty = true
				@update!
				@controller.trigger \set-posts posts
			.catch (err) ~>
				console.error err

	@stream.on \post (post) ~>
		@is-empty = false
		@update!
		@controller.trigger \add-post post

		if document.hidden
			@unread-count++
			# TODO
			document.title = '(' + @unread-count + ') ' + 'hoge'

	@window-on-visibilitychange = ~>
		if !document.hidden
			@unread-count = 0
			document.title = 'Misskey'
