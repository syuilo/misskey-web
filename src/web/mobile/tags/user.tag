mk-user
	div.user(if={ !fetching })
		header
			div.banner(style={ user.banner_url ? 'background-image: url(' + user.banner_url + '?thumbnail&size=1024)' : '' })
			div.body
				div.top
					a.avatar: img(src={ user.avatar_url + '?thumbnail&size=128' }, alt='avatar')
					mk-follow-button(user={ user-promise })

				div.title
					h1 { user.name }
					span.username @{ user.username }
					span.followed(if={ user.is_followed }) フォローされています

				div.bio { user.bio }

				div.info
					p.location(if={ user.location })
						i.fa.fa-map-marker
						| { user.location }

				div.friends
					a
						b { user.following_count }
						i フォロー
					a
						b { user.followers_count }
						i フォロワー

		div.body
			mk-user-timeline(if={ page == 'home' }, user={ user-promise })
			mk-user-graphs(if={ page == 'graphs' }, user={ user-promise })

style.
	display block
	background #fff

	> .user
		> header
			> .banner
				padding-bottom 33.3%
				background-color #f5f5f5
				background-size cover
				background-position center

			> .body
				padding 8px
				margin 0 auto
				max-width 600px

				> .top
					&:after
						content ''
						display block
						clear both

					> .avatar
						display block
						position relative
						float left
						width 25%
						height 40px

						> img
							display block
							position absolute
							left -2px
							bottom -2px
							box-sizing border-box
							width 100%
							border 2px solid #fff
							border-radius 6px

							@media (min-width 500px)
								left -4px
								bottom -4px
								border 4px solid #fff

					> mk-follow-button
						float right
						height 40px

				> .title
					margin 8px 0

					> h1
						margin 0
						line-height 22px
						font-size 20px
						color #222

					> .username
						display inline-block
						line-height 20px
						font-size 16px
						font-weight bold
						color #657786

					> .followed
						margin-left 8px
						padding 2px 4px
						font-size 12px
						color #666
						background #fafafa
						border-radius 4px

				> .bio
					margin 8px 0
					color #333

				> .info
					margin 8px 0

					> .location
						display inline
						margin 0
						color #555

						> i
							margin-right 4px

				> .friends
					> a
						color #657786

						&:first-child
							margin-right 16px

						> b
							margin-right 4px
							font-size 16px
							color #14171a

						> i
							font-size 14px

script.
	@mixin \api

	@event = @opts.event
	@username = @opts.user
	@page = if @opts.page? then @opts.page else \home
	@fetching = true

	@user-promise = new Promise (resolve, reject) ~>
		@api \users/show do
			username: @username
		.then (user) ~>
			@fetching = false
			@user = user
			@update!
			@event.trigger \loaded user
			resolve user

	@on \mount ~>
		@user-promise.then!
