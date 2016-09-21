mk-home
	div.main
		div.widgets.side-left@left: div.body
			mk-profile-home-widget
			mk-calendar-home-widget
			mk-rss-reader-home-widget
			mk-photo-stream-home-widget
		main.widgets: div.body
			mk-timeline-home-widget(event={ tl-event })
		div.widgets.side-right@right: div.body
			mk-broadcast-home-widget
			mk-notifications-home-widget
			mk-user-recommendation-home-widget
			mk-donate-home-widget
			mk-nav-home-widget
			mk-tip-home-widget
	mk-detect-slow-internet-connection-notice

style.
	display block
	background #fdfdfd

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

	@tl-event = riot.observable!

	@on \mount ~>
		window.add-event-listener \load @follow-sidebar
		window.add-event-listener \scroll @follow-sidebar
		window.add-event-listener \resize @follow-sidebar

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
