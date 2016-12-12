mk-post-form-window

	mk-window@window(controller={ window-controller }, is-modal={ true }, colored={ true })

		<yield to="header">
		span(if={ !parent.opts.reply }) 新規投稿
		span(if={ parent.opts.reply }) 返信
		span.files(if={ parent.files.length != 0 }) 添付: { parent.files.length }ファイル
		span.uploading-files(if={ parent.uploading-files.length != 0 })
			| { parent.uploading-files.length }個のファイルをアップロード中
			mk-ellipsis
		</yield>

		<yield to="content">
		div.ref(if={ parent.opts.reply })
			mk-post-preview(post={ parent.opts.reply })
		div.body
			mk-post-form@form(event={ parent.form-event }, reply={ parent.opts.reply })
		</yield>

style.
	> mk-window

		[data-yield='header']
			> .files
			> .uploading-files
				margin-left 8px
				opacity 0.8

				&:before
					content '('

				&:after
					content ')'

		[data-yield='content']
			> .ref
				> mk-post-preview
					margin 16px 22px

script.
	@wait = false

	@uploading-files = []
	@files = []

	@window-controller = riot.observable!
	@form-event = riot.observable!

	@on \mount ~>
		@form = @refs.window.refs.form
		@open!

	@window-controller.on \closed ~>
		@unmount!

	@form-event.on \post ~>
		@close!

	@form-event.on \change-uploading-files (files) ~>
		@uploading-files = files
		@update!

	@form-event.on \change-files (files) ~>
		@files = files
		@update!

	@open = ~>
		@window-controller.trigger \open
		@form.focus!

	@close = ~>
		@window-controller.trigger \close
