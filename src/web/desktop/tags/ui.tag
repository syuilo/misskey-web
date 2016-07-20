mk-ui
	mk-post-form(ui={ui})

	mk-global@global
		mk-header@header(ui={ui})

		mk-contents
			| <yield/>

	mk-go-top

script.
	@ui = riot.observable!

	@ui.on \on-blur ~>
		Velocity @global, { blur: 5 } 100ms

	@ui.on \off-blur ~>
		Velocity @global, { blur: 0 } 100ms

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
