mk-ui
	mk-post-form-window(controller={ post-form-controller })

	div.global@global
		mk-ui-header@header(ui={ ui })

		mk-set-avatar-suggestion(if={ SIGNIN && I.avatar_id == null })
		mk-set-banner-suggestion(if={ SIGNIN && I.banner_id == null })

		div.content
			<yield />

	mk-stream-indicator

style.
	display block

script.
	@mixin \i

	@ui = riot.observable!
	riot.mixin \ui do
		ui: @ui

	@post-form-controller = riot.observable!

	@ui.on \toggle-post-form ~>
		@post-form-controller.trigger \toggle

	@ui.on \notification (text) ~>
		alert text

	@ui.on \set-root-layout ~>
		@set-root-layout!

	@set-root-layout = ~>
		@root.style.padding-top = @refs.header.root.client-height + \px

	@on \mount ~>
		@set-root-layout!
		document.add-event-listener \keydown (e) ~>
			tag = e.target.tag-name.to-lower-case!
			if tag != \input and tag != \textarea
				if e.which == 80 or e.which == 78 # p or n
					e.prevent-default!
					@post-form-controller.trigger \open
