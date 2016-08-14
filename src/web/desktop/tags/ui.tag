mk-ui
	mk-post-form(controller={ post-form-controller })

	div.global@global
		mk-header@header(ui={ ui })

		mk-contents
			| <yield/>

	mk-go-top

style.
	display block

	> .global
		display block

script.
	@ui = riot.observable!
	@post-form-controller = riot.observable!

	@post-form-controller.on \opened ~>
		@ui.trigger \blur

	@post-form-controller.on \closed ~>
		@ui.trigger \unblur 300ms

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
