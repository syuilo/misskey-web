mk-ui
	mk-post-form-window(controller={ post-form-controller })

	div.global@global
		mk-ui-header@header(ui={ ui })

		div.contents
			| <yield/>

	mk-go-top

style.
	display block

script.
	# ↓ CSS backdrop-filter が広く実装され次第廃止(主にChrome待ち)
	@ui = riot.observable!
	riot.mixin \ui do
		ui: @ui

	@post-form-controller = riot.observable!

	@ui.on \toggle-post-form ~>
		@post-form-controller.trigger \toggle

	@post-form-controller.on \opening ~>
		@ui.trigger \blur 100ms

	@post-form-controller.on \closing ~>
		@ui.trigger \unblur 300ms

	@ui.on \blur (duration = 100ms) ~>
		Velocity @global, \finish true
		Velocity @global, { blur: 5 } duration

	@ui.on \unblur (duration = 100ms) ~>
		Velocity @global, \finish true
		Velocity @global, { blur: 0 } duration

	@ui.on \notification (text) ~>
		alert text

	@on \mount ~>
		document.body.style.margin-top = @header.client-height + \px
