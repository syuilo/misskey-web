mk-user
	div.user(if={ !fetching })
		header@header
		div.body
			div.side: div.body@side
			main: div.body@main

style.
	display block
	background #fbfbfb

	> .user
		> header
			box-sizing border-box
			max-width 560px + 270px
			margin 0 auto
			padding 0 16px

			> mk-user-header
				border solid 1px rgba(0, 0, 0, 0.075)
				border-top none
				border-radius 0 0 6px 6px
				overflow hidden

		> .body
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

		api \users/show do
			username: @username
		.then (user) ~>
			@user = user
			@fetching = false
			@event.trigger \user-fetched

			e = @header.append-child document.create-element \mk-user-header
			riot.mount e, do
				user: @user

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
