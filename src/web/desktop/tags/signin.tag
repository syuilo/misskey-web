mk-signin
	form(onsubmit={ onsubmit })
		h2.title
			img#avatar(src='', href='')
			p アカウント
		a.help(href= config.urls.help, title='お困りですか？'): i.fa.fa-question
		label.user-name
			input@username(
				type='text'
				pattern='^[a-zA-Z0-9\-]+$'
				placeholder='ユーザー名'
				autofocus
				required)
			i.fa.fa-at
		label.password
			input@password(
				type='password'
				placeholder='パスワード'
				required)
			i.fa.fa-lock
		button(type='submit') サインイン

style.
	display block

	> form
		display block
		position relative
		z-index 2
		box-sizing border-box
		padding 10px 32px 0 32px
		background #fff
		background-clip padding-box
		border solid 1px rgba(0, 0, 0, 0.1)
		border-radius 4px

		&:hover
			> .help
				opacity 1

		h2
			display block
			margin 0
			padding 0
			height 54px
			line-height 54px
			text-align center
			text-transform uppercase
			font-size 1em
			font-weight bold
			color #888
			border-bottom solid 1px #eee

			p
				display inline
				margin 0
				padding 0

			#avatar
				display inline-block
				position relative
				top 10px
				width 32px
				height 32px
				margin-right 8px
				border-radius 100%

				&[src='']
					display none

		> .help
			appearance none
			cursor pointer
			display block
			position absolute
			top 0
			right 0
			z-index 1
			margin 0
			padding 0
			font-size 1.2em
			color #999
			border none
			outline none
			box-shadow none
			background transparent
			opacity 0
			transition opacity 0.1s ease

			&:hover
				color #444

			&:active
				color #222

			> i
				padding 14px

		label
			display block
			position relative
			margin 12px 0

			i
				display block
				pointer-events none
				position absolute
				bottom 0
				top 0
				left 0
				z-index 1
				margin auto
				padding 0 16px
				height 1em
				color #898786

			input[type=text],
			input[type=password]
				appearance none
				user-select text
				display inline-block
				cursor auto
				box-sizing border-box
				padding 0 0 0 38px
				margin 0
				width 100%
				line-height 44px
				font-size 1em
				color #333 !important
				background #fff !important
				outline none
				border solid 1px rgba(0, 0, 0, 0.1)
				border-radius 4px
				box-shadow 0 0 0 114514px #fff inset
				transition all .3s ease
				font-family 'Meiryo', 'メイリオ', 'Meiryo UI', sans-serif !important

				&:hover
					border-color rgba(0, 0, 0, 0.2)
					transition all .1s ease

				&:focus
					color $theme-color !important
					border-color $theme-color
					box-shadow 0 0 0 1024px #fff inset, 0 0 0 4px rgba($theme-color, 10%)
					transition all 0s ease

				&:disabled
					opacity 0.5

				&:hover + i
					color #797776

		[type=submit]
			appearance none
			cursor pointer
			box-sizing border-box
			padding 16px 16px 32px 16px
			margin -6px 0 0 0
			width 100%
			font-size 1.2em
			color #555
			outline none
			border none
			border-radius 0
			box-shadow none
			background transparent
			transition all .5s ease

			&:hover
				color $theme-color
				transition all .2s ease

			&:focus
				color $theme-color
				transition all .2s ease

			&:active
				color darken($theme-color, 30%)
				transition all .2s ease

script.
	@onsubmit = ~>
		api CONFIG.urls.signin, do
			username: @username.value
			password: @password.value
		.then ->
			location.reload!
		.catch ->
			alert \a
