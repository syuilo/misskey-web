mk-home
	div.main
		div.widgets.side-left@left: div.body@left-body
		main.widgets: div.body
			mk-timeline-home-widget(event={ tl-event })
		div.widgets.side-right@right: div.body@right-body
	mk-detect-slow-internet-connection-notice

style.
	display block

	> .main
		display -webkit-flex
		display -moz-flex
		display -ms-flex
		display flex
		justify-content center
		position relative

		//background-image url('/_/resources/desktop/pages/home/nyaruko.jpg')
		//background-position center center
		//background-attachment fixed
		//background-size cover

		> .widgets
			> .body
				> *
					display block
					position relative
					background-clip padding-box
					//border solid 1px #eaeaea
					border solid 1px rgba(0, 0, 0, 0.075)
					border-radius 6px
					overflow hidden

					&:not(:last-child)
						margin-bottom 16px

		> main
			position relative
			flex 1 1 560px
			box-sizing border-box
			max-width 560px
			margin 0
			padding 0

			> .body
				padding 16px

		> .side-left
			position relative
			flex 1 1 270px
			max-width 270px
			margin 0
			padding 0

			> .body
				padding 16px 0 16px 16px

		> .side-right
			position relative
			flex 1 1 270px
			max-width 270px
			margin 0
			padding 0

			> .body
				padding 16px 16px 16px 0

script.
	@event = @opts.event

	@home = []
	@tl-event = riot.observable!

	@on \mount ~>
		window.add-event-listener \load @follow-sidebar
		window.add-event-listener \scroll @follow-sidebar
		window.add-event-listener \resize @follow-sidebar

		I.data.home.for-each (widget) ~>
			el = document.create-element \mk- + widget.name + \-home-widget
			switch widget.place
				| \left => @left-body.append-child el
				| \right => @right-body.append-child el
			@home.push (riot.mount el, do
				id: widget.id
				data: widget.data
			.0)

	@on \unmount ~>
		window.remove-event-listener \load @follow-sidebar
		window.remove-event-listener \scroll @follow-sidebar
		window.remove-event-listener \resize @follow-sidebar

		@home.for-each (widget) ~>
			widget.unmount!

	@tl-event.on \loaded ~>
		@event.trigger \loaded

	@follow-sidebar = ~>
		window-top = window.scroll-y
		window-height = window.inner-height
		html-height = document.body.offset-height

		follow @left
		follow @right

		function follow(el)
			body = el.children.0
			top = el.get-bounding-client-rect!.top + window-top
			height = body.offset-height

			overflow = (top + height) - window-height
			if overflow < 0 then overflow = 0
			if window-top + window-height > top + height
				margin = window-top - overflow
				body.style.margin-top = margin + \px
			else
				body.style.margin-top = 0
