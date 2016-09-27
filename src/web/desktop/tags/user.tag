mk-user
	div.user(if={ !fetching })
		header
			mk-user-header(user={ user-promise })
		div.body
			div.side: div.body
				mk-user-profile(user={ user-promise })
				mk-user-photos(user={ user-promise })
			main: div.body
				mk-user-timeline(user={ user-promise }, event={ tl-event })

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
	@fetching = true
	@tl-event = riot.observable!

	@user-promise = new Promise (resolve, reject) ~>
		api \users/show do
			username: @username
		.then (user) ~>
			@fetching = false
			@update!
			@event.trigger \user-fetched
			resolve user

	@tl-event.on \loaded ~>
		@event.trigger \loaded
