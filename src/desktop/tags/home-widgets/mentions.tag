mk-mentions-home-widget
	div.loading(if={ is-loading })
		mk-ellipsis-icon
	p.empty(if={ is-empty })
		i.fa.fa-comments-o
		| あなた宛ての投稿はありません。
	mk-timeline@timeline(controller={ controller })
		<yield to="footer">
		i.fa.fa-moon-o(if={ !parent.more-loading })
		i.fa.fa-spinner.fa-pulse.fa-fw(if={ parent.more-loading })
		</yield>

style.
	display block
	background #fff

	> .loading
		padding 64px 0

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
	@mixin \i
	@mixin \api
	@mixin \stream

	@is-loading = true
	@is-empty = false
	@more-loading = false
	@controller = riot.observable!
	@event = @opts.event

	@on \mount ~>
		@stream.on \mention @on-mention

		document.add-event-listener \keydown @on-document-keydown
		window.add-event-listener \scroll @on-scroll

		@load ~>
			@event.trigger \loaded

	@on \unmount ~>
		@stream.off \mention @on-mention

		document.remove-event-listener \keydown @on-document-keydown
		window.remove-event-listener \scroll @on-scroll

	@on-document-keydown = (e) ~>
		tag = e.target.tag-name.to-lower-case!
		if tag != \input and tag != \textarea
			if e.which == 84 # t
				@controller.trigger \focus

	@load = (cb) ~>
		@api \posts/mentions
		.then (posts) ~>
			@is-loading = false
			@is-empty = posts.length == 0
			@update!
			@controller.trigger \set-posts posts
			if cb? then cb!
		.catch (err) ~>
			console.error err
			if cb? then cb!

	@more = ~>
		if @more-loading or @is-loading or @refs.timeline.posts.length == 0
			return
		@more-loading = true
		@update!
		@api \posts/mentions do
			max_id: @refs.timeline.tail!.id
		.then (posts) ~>
			@more-loading = false
			@update!
			@controller.trigger \prepend-posts posts
		.catch (err) ~>
			console.error err

	@on-mention = (post) ~>
		@is-empty = false
		@update!
		@controller.trigger \add-post post

	@on-scroll = ~>
		current = window.scroll-y + window.inner-height
		if current > document.body.offset-height - 8
			@more!
