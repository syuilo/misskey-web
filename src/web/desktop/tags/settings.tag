mk-settings
	div.nav
		p(class={ active: page == 'account' }, onclick={ page-account })
			i.fa.fa-fw.fa-user
			| アカウント
		p(class={ active: page == 'drive' }, onclick={ page-drive })
			i.fa.fa-fw.fa-cloud
			| ドライブ
		p(class={ active: page == 'apps' }, onclick={ page-apps })
			i.fa.fa-fw.fa-puzzle-piece
			| アプリ
		p(class={ active: page == 'signin' }, onclick={ page-signin })
			i.fa.fa-fw.fa-sign-in
			| ログイン履歴
		p(class={ active: page == 'password' }, onclick={ page-password })
			i.fa.fa-fw.fa-unlock-alt
			| パスワード
	div.pages
		section.account(show={ page == 'account' })
			h1 アカウント
			div.avatar
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
		cursor pointer

		> p
			display block
			padding 10px
			margin 0 0 -1px 0
			color lighten($theme-color, 30%)
			background rgba(#fff, 0.5)
			border-top solid 1px lighten($theme-color, 85%)
			border-bottom solid 1px lighten($theme-color, 85%)

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

			div
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
		browser = document.body.append-child document.create-element \mk-select-file-from-drive-window
		browser-controller = riot.observable!
		riot.mount browser, do
			multiple: false
			controller: browser-controller
		browser-controller.trigger \open
		browser-controller.one \selected (file) ~>
			cropper = document.body.append-child document.create-element \mk-crop-window
			cropper-controller = riot.observable!
			riot.mount cropper, do
				file: file
				title: 'アバターとして表示する部分を選択'
				controller: cropper-controller
			cropper-controller.trigger \open
			cropper-controller.on \cropped (blob) ~>
				data = new FormData!
				data.append \_i USER._web
				data.append \file blob, file.name + '.cropped.png'
				api 'drive/folders/find' do
					name: 'アイコン'
				.then (icon-folder) ~>
					if icon-folder.length == 0
						api 'drive/folders/create' do
							name: 'アイコン'
						.then (icon-folder) ~>
							@avatar-uplaod data, icon-folder
					else
						@avatar-uplaod data, icon-folder.0

		@avatar-uplaod = (data, folder) ~>

			if folder?
				data.append \folder folder.id

			xhr = new XMLHttpRequest!
			xhr.open \POST CONFIG.api.url + '/drive/files/create' true
			xhr.onload = (e) ~>
				file = JSON.parse e.target.response

				api 'i/update' do
					avatar: file.id
				.then (i) ~>
					# something
					@user.avatar_url = i.avatar_url
					@update!
				.catch (err) ~>
					console.error err
					#@opts.ui.trigger \notification 'Error!'

			#xhr.upload.onprogress = (e) ~>
			#	if e.length-computable
			#		if ctx.progress == undefined
			#			ctx.progress = {}
			#		ctx.progress.max = e.total
			#		ctx.progress.value = e.loaded
			#		@update!

			xhr.send data

	@update-account = ~>
		api 'i/update' do
			name: @account-name.value
			location: @account-location.value
			bio: @account-bio.value
		.then (i) ~>
			alert \ok
		.catch (err) ~>
			console.error err
