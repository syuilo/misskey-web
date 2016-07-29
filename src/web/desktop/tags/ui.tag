mk-ui
	mk-post-form(ui={ui})

	div.global@global
		mk-header@header(ui={ui})

		mk-contents
			| <yield/>

	mk-go-top

style.
	display block

	> .global
		display block

script.
	@ui = riot.observable!

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

		window.add-event-listener \load @on-scroll
		window.add-event-listener \scroll @on-scroll
		window.add-event-listener \resize @on-scroll

	@on-scroll = ~>
		t = window.page-y-offset
		opacity = t / 128
		if opacity > 0.3 then opacity = 0.3
		@header.style.box-shadow = "0 0 1px rgba(0, 0, 0, " + opacity + ")"
