mk-autocomplete-suggestion
	ol.users(if={ users.length > 0 })
		li(each={ user in users })
			a(onclick={ user._click })
				img.avatar(src={ user.avatar_url + '?thumbnail&size=32' }, alt='')
				span.name { user.name }
				span.username @{ user.username }

style.
	display block
	position absolute
	z-index 65535
	margin-top calc(1em + 8px)
	max-height 190px
	max-width 500px
	overflow auto
	background #fff
	background-clip padding-box
	border solid 1px rgba(0, 0, 0, 0.1)
	border-radius 4px
	font-family 'Meiryo', 'メイリオ', sans-serif

	> .users
		margin 0
		padding 4px 0
		list-style none

		> li
			> a
				display inline-block
				z-index 1
				box-sizing border-box
				width 100%
				padding 4px 12px
				vertical-align top
				white-space nowrap
				overflow hidden
				font-size 0.9em
				color rgba(0, 0, 0, 0.8)
				text-decoration none
				transition none

				&:hover
					color #fff
					background $theme-color

					.name
						color #fff

					.username
						color #fff

				&:active
					color #fff
					background darken($theme-color, 10%)

					.name
						color #fff

					.username
						color #fff

				.avatar
					vertical-align middle
					min-width 28px
					min-height 28px
					max-width 28px
					max-height 28px
					margin 0 8px 0 0
					border-radius 100%

				.name
					margin 0 8px 0 0
					/*font-weight bold*/
					font-weight normal
					color rgba(0, 0, 0, 0.8)

				.username
					font-weight normal
					color rgba(0, 0, 0, 0.3)

script.
	@q = @opts.q
	@textarea = @opts.textarea
	@loading = true
	@users = []

	@on \mount ~>
		@textarea.add-event-listener \keydown @on-keydown

		api \users/search do
			query: @q
		.then (users) ~>
			users.for-each (user) ~>
				user._click = ~>
					# hoge
			@users = users
			@loading = false
			@update!
		.catch (err) ~>
			console.error err

	@on \unmount ~>
		@textarea.remove-event-listener \keydown @on-keydown

	@on-keydown = (e) ~>
		console.log e.which
		key = e.which
		switch (key)
			| 10, 13 => # Key[ENTER]
				#hoge
			| 27 => # Key[ESC]
				#hoge
			| 38 => # Key[↑]
				#hoge
			| 9, 40 => # Key[TAB] or Key[↓]
				#hoge
