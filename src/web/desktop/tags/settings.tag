mk-settings
	div.nav
		p(class={ active: page == 'account' }, onmousedown={ page-account })
			i.fa.fa-fw.fa-user
			| アカウント
		p(class={ active: page == 'web' }, onmousedown={ page-web })
			i.fa.fa-fw.fa-desktop
			| Web
		p(class={ active: page == 'notification' }, onmousedown={ page-notification })
			i.fa.fa-fw.fa-bell-o
			| 通知
		p(class={ active: page == 'drive' }, onmousedown={ page-drive })
			i.fa.fa-fw.fa-cloud
			| ドライブ
		p(class={ active: page == 'apps' }, onmousedown={ page-apps })
			i.fa.fa-fw.fa-puzzle-piece
			| アプリ
		p(class={ active: page == 'signin' }, onmousedown={ page-signin })
			i.fa.fa-fw.fa-sign-in
			| ログイン履歴
		p(class={ active: page == 'password' }, onmousedown={ page-password })
			i.fa.fa-fw.fa-unlock-alt
			| パスワード
	div.pages
		section.account(show={ page == 'account' })
			h1 アカウント
			div.id
				p ユーザーID:
				code { user.id }
			label.avatar
				p アバター
				img.avatar(src={ user.avatar_url + '?thumbnail&size=64' }, alt='avatar')
				button.style-normal(onclick={ avatar }) 画像を選択
			label
				p 名前
				input@account-name(type='text', value={ user.name })
			label
				p 場所
				input@account-location(type='text', value={ user.location })
			label
				p 自己紹介
				textarea@account-bio { user.bio }
			button.style-primary(onclick={ update-account }) 保存

style.
	display block

	> .nav
		position absolute
		top 0
		left 0
		width 200px
		height 100%
		box-sizing border-box
		padding 16px 0 0 0
		background lighten($theme-color, 95%)
		border-right solid 1px lighten($theme-color, 85%)

		> p
			display block
			padding 10px
			margin 0 0 -1px 0
			color lighten($theme-color, 30%)
			background rgba(#fff, 0.5)
			border-top solid 1px lighten($theme-color, 85%)
			border-bottom solid 1px lighten($theme-color, 85%)
			cursor pointer

			-ms-user-select none
			-moz-user-select none
			-webkit-user-select none
			user-select none

			> i
				margin-right 4px

			&.active
				color $theme-color
				background #fff
				border-top solid 1px lighten($theme-color, 85%)
				border-bottom solid 1px lighten($theme-color, 85%)
				box-shadow 1px 0 #fff

	> .pages
		position absolute
		top 0
		left 200px
		width calc(100% - 200px)

		> section
			padding 32px

			& + section
				margin-top 16px

			h1
				display block
				margin 0
				padding 0 0 8px 0
				font-size 1em
				color #555
				border-bottom solid 1px #eee

			label
				display block
				margin 16px 0

				&:after
					content ""
					display block
					clear both

				> p
					margin 0 0 8px 0
					font-weight bold
					color #666

			&.account
				> .id
					position absolute
					top 32px
					right 34px
					color #aaa

					> p
						display inline
						margin 0 4px 0 0
						font-weight bold

				> .avatar
					position relative

					> img
						display block
						float left
						width 64px
						height 64px
						border-radius 4px

					> button
						float left
						margin-left 8px

script.
	@mixin \dialog
	@mixin \update-avatar

	@user = window.I
	@page = \account

	@page-account = ~>
		@page = \account

	@page-apps = ~>
		@page = \apps

	@page-drive = ~>
		@page = \drive

	@page-signin = ~>
		@page = \signin

	@page-password = ~>
		@page = \password

	@avatar = ~>
		@update-avatar (i) ~>
			@user.avatar_url = i.avatar_url
			@update!

	@update-account = ~>
		api 'i/update' do
			name: @account-name.value
			location: @account-location.value
			bio: @account-bio.value
		.then (i) ~>
			alert \ok
		.catch (err) ~>
			console.error err
