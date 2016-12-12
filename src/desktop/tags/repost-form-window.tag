mk-repost-form-window
	mk-window(controller={ window-controller }, is-modal={ true }, colored={ true })
		<yield to="header">
		i.fa.fa-retweet
		| この投稿をRepostしますか？
		</yield>
		<yield to="content">
		mk-repost-form(post={ parent.opts.post }, event={ parent.event })
		</yield>

style.
	> mk-window
		[data-yield='header']
			> i
				margin-right 4px

script.
	@window-controller = riot.observable!
	@event = riot.observable!

	@event.on \cancel ~>
		@window-controller.trigger \close

	@event.on \posted ~>
		@window-controller.trigger \close

	@window-controller.on \closed ~>
		@unmount!

	@on-document-keydown = (e) ~>
		tag = e.target.tag-name.to-lower-case!
		if tag != \input and tag != \textarea
			if e.which == 27 # Esc
				@window-controller.trigger \close

	@on \mount ~>
		@window-controller.trigger \open
		document.add-event-listener \keydown @on-document-keydown

	@on \unmount ~>
		document.remove-event-listener \keydown @on-document-keydown
