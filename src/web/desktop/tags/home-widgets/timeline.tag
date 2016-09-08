mk-timeline-home-widget
	mk-following-setuper(if={ no-following })
	div.loading(if={ is-loading })
		mk-ellipsis-icon
	p.empty(if={ is-empty })
		i.fa.fa-comments-o
		| 自分の投稿や、自分がフォローしているユーザーの投稿が表示されます。
	mk-timeline(controller={ controller })

style.
	display block
	background #fff

	> mk-following-setuper
		border-bottom solid 1px #eee

	> .loading
		padding 32px

	> .empty
		display block
		margin 0 auto
		padding 32px
		max-width 400px
		text-align center
		color #999

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
	@no-following = I.following_count == 0
	@unread-count = 0
	@controller = riot.observable!

	@on \mount ~>
		@stream.on \post @on-stream-post
		@stream.on \follow @on-stream-follow
		@stream.on \unfollow @on-stream-unfollow

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
		@stream.off \unfollow @on-stream-unfollow
	
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

	@on-stream-unfollow = ~>
		@load!

	@window-on-visibilitychange = ~>
		if !document.hidden
			@unread-count = 0
			document.title = 'Misskey'
