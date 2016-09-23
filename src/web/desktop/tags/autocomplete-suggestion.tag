mk-autocomplete-suggestion
	ol.users(if={ users.length > 0 })
		virtual(each={ user in users })
			li(onclick={ user._click }, class={ selected: user._selected })
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
			display block
			box-sizing border-box
			padding 4px 12px
			white-space nowrap
			overflow hidden
			font-size 0.9em
			color rgba(0, 0, 0, 0.8)
			cursor default

			&, *
				user-select none

			&:hover
			&.selected
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
	@select = -1

	@on \mount ~>
		@textarea.add-event-listener \keydown @on-keydown

		api \users/search do
			query: @q
		.then (users) ~>
			users.for-each (user) ~>
				user._click = ~>
					@complete user
			@users = users
			@loading = false
			@update!
		.catch (err) ~>
			console.error err

	@on \unmount ~>
		@textarea.remove-event-listener \keydown @on-keydown

	@on-keydown = (e) ~>
		key = e.which
		switch (key)
			| 10, 13 => # Key[ENTER]
				e.prevent-default!
				e.stop-propagation!
				@complete @users[@select]
			| 27 => # Key[ESC]
				@close!
			| 38 => # Key[↑]
				if @select != -1
					e.prevent-default!
					e.stop-propagation!
					@select-prev!
				else
					@close!
			| 9, 40 => # Key[TAB] or Key[↓]
				e.prevent-default!
				e.stop-propagation!
				@select-next!

	@select-next = ~>
		@select++

		if @select >= @users.length
			@select = 0

		@apply-select!

	@select-prev = ~>
		@select--

		if @select < 0
			@select = @users.length - 1

		@apply-select!

	@apply-select = ~>
		@users.for-each (user) ~>
			user._selected = false

		@users[@select]._selected = true

		@update!

	@complete = (user) ~>
		@opts.complete user

	@close = ~>
		@opts.close!
