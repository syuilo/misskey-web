mk-timeline-home-widget
	p.loading(if={ is-loading })
		i.fa.fa-spinner.fa-pulse.fa-fw
		| 読み込んでいます...
	p.empty(if={ is-empty })
		i.fa.fa-comments-o
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
	
	> .empty
		margin 0 auto
		padding 32px
		max-width 400px

		> i
			display block
			margin-bottom 16px
			font-size 3em
			color #ccc

script.
	@mixin \stream
	@mixin \get-post-summary

	@is-loading = true
	@is-empty = false
	@unread-count = 0
	@controller = riot.observable!

	@on \mount ~>
		@stream.on \post @on-stream-post
		@stream.on \follow @on-stream-follow

		document.add-event-listener \visibilitychange @window-on-visibilitychange, false
		document.add-event-listener \keydown (e) ~>
			tag = e.target.tag-name.to-lower-case!
			if tag != \input and tag != \textarea
				if e.which == 84 # t
					@controller.trigger \focus

		@load!

	@on \unmount ~>
		@stream.off \post @on-stream-post
		@stream.off \follow @on-stream-follow
	
	@load = ~>
		@controller.trigger \clear
		@is-loading = true
		@update!
		api \posts/timeline
		.then (posts) ~>
			@is-loading = false
			if posts.length == 0
				@is-empty = true
			else
				@is-empty = false
			@update!
			@controller.trigger \set-posts posts
		.catch (err) ~>
			console.error err

	@on-stream-post = (post) ~>
		@is-empty = false
		@update!
		@controller.trigger \add-post post

		if document.hidden
			@unread-count++
			document.title = '(' + @unread-count + ') ' + @get-post-summary post
	
	@on-stream-follow = ~>
		@load!

	@window-on-visibilitychange = ~>
		if !document.hidden
			@unread-count = 0
			document.title = 'Misskey'
