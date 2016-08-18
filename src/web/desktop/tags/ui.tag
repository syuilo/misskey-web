mk-ui
	mk-post-form-window(controller={ post-form-controller })

	div.global@global
		mk-header@header(ui={ ui })

		div.contents
			| <yield/>

	mk-go-top

style.
	display block

script.
	@ui = riot.observable!
	riot.mixin \ui do
		ui: @ui
		input-dialog: (title, placeholder, default-value, on-ok, on-cancel) ~>
			dialog = document.body.append-child document.create-element \mk-input-dialog
			riot.mount dialog, do
				title: title
				placeholder: placeholder
				default: default-value
				on-ok: on-ok
				on-cancel: on-cancel

	@post-form-controller = riot.observable!

	@ui.on \toggle-post-form ~>
		@post-form-controller.trigger \toggle

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
