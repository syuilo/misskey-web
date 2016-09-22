mk-user
	div.main(if={ !fetching })
		div.side: div.body@side
		main: div.body@main

style.
	display block
	background #fbfbfb

	> .main
		display -webkit-flex
		display -moz-flex
		display -ms-flex
		display flex
		justify-content center
		position relative

		> *
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

		> .side
			position relative
			flex 1 1 270px
			max-width 270px
			margin 0
			padding 0

			> .body
				padding 16px 0 16px 16px

script.
	@event = @opts.event
	@username = @opts.user
	@user = null
	@fetching = true
	@tl-event = riot.observable!

	@on \mount ~>
		window.add-event-listener \load @follow-sidebar
		window.add-event-listener \scroll @follow-sidebar
		window.add-event-listener \resize @follow-sidebar

		api \users/show do
			username: @username
		.then (user) ~>
			@user = user
			@fetching = false

			e = @side.append-child document.create-element \mk-user-profile
			riot.mount e, do
				user: @user

			e = @side.append-child document.create-element \mk-user-photos
			riot.mount e, do
				user: @user

			e = @main.append-child document.create-element \mk-user-timeline
			riot.mount e, do
				user: @user
				event: @tl-event

			@update!
		.catch (err) ~>
			console.error err

	@tl-event.on \loaded ~>
		@event.trigger \loaded

	@follow-sidebar = ~>
		window-top = window.scroll-y
		window-height = window.inner-height
		html-height = document.body.offset-height

		follow @side.parent-element

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
