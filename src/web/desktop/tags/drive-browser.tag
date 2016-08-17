mk-drive-browser
	nav
		ol.path
			li.root(class={ current: folder == null }, onclick={ go-root })
				i.fa.fa-cloud
				| ドライブ
			virtual(each={ folder in hierarchy-folders })
				li.separator: i.fa.fa-angle-right
				li.folder(onclick={ folder._click })
					| { folder.name }
			li.separator(if={ folder != null }): i.fa.fa-angle-right
			li.folder.current(if={ folder != null })
				| { folder.name }
		input.search(type='search', placeholder!='&#xf002; 検索')
	div.main@main(class={ uploading: uploads.length > 0, loading: loading })
		div.folders
			virtual(each={ folder in folders })
				div.folder(onclick={ folder._click }, title={ folder._title })
					p.name
						i.fa.fa-folder-o
						| { folder.name }
		div.files(if={ files.length > 0 })
			virtual(each={ file in files })
				div.file(class={ selected: file._selected }, onclick={ file._click }, title={ file._title })
					img(src={ file.url + '?thumbnail&size=128' }, alt='')
					p.name
						| { file.name.lastIndexOf('.') != -1 ? file.name.substr(0, file.name.lastIndexOf('.')) : file.name }
						span.ext(if={ file.name.lastIndexOf('.') != -1 }) { file.name.substr(file.name.lastIndexOf('.')) }
		div.no-files(if={ files.length == 0 && !loading })
			p ファイルはありません。
		div.loading(if={ loading }).
			<div class="spinner">
				<div class="dot1"></div>
				<div class="dot2"></div>
			</div>
	mk-uploader(controller={ uploader-controller })
	input@file-input(type='file', accept='*/*', multiple, tabindex='-1', onchange={ change-file-input })

style.
	display block

	> nav
		display block
		position relative
		box-sizing border-box
		width 100%
		overflow auto
		font-size 0.9em
		color #555
		background #fff
		//border-bottom 1px solid #dfdfdf
		box-shadow 0 1px 0 rgba(0, 0, 0, 0.05)

		&, *
			-ms-user-select none
			-moz-user-select none
			-webkit-user-select none
			user-select none

		> .path
			display inline-block
			vertical-align bottom
			box-sizing border-box
			margin 0
			padding 0 16px
			width calc(100% - 200px)
			line-height 38px
			list-style none
			white-space nowrap

			> li
				display inline
				margin 0
				padding 0
				cursor pointer

				i
					margin-right 4px

				&:hover
					text-decoration underline

				&.current
					font-weight bold
					cursor default

					&:hover
						text-decoration none

				&.separator
					margin 0 8px
					opacity 0.5

					> i
						margin 0

		> .search
			display inline-block
			vertical-align bottom
			-webkit-appearance none
			-moz-appearance none
			appearance none
			user-select text
			-moz-user-select text
			-webkit-user-select text
			-ms-user-select text
			cursor auto
			box-sizing border-box
			margin 0
			padding 0 18px
			width 200px
			font-size 1em
			line-height 38px
			background transparent
			outline none
			//border solid 1px #ddd
			border none
			border-radius 0
			box-shadow none
			transition color 0.5s ease, border 0.5s ease
			font-family FontAwesome, 'Meiryo UI', 'Meiryo', 'メイリオ', sans-serif

			&[data-active='true']
				background #fff

			&::-webkit-input-placeholder,
			&:-ms-input-placeholder,
			&:-moz-placeholder
				color $ui-controll-foreground-color

	> .main
		position relative
		box-sizing border-box
		padding 8px
		height calc(100% - 38px)
		overflow auto

		&.loading
			&, *
				cursor wait !important

		&.uploading
			height calc(100% - 38px - 100px)

		> .folders
			&:after
				content ""
				display block
				clear both

			> .folder
				float left
				box-sizing border-box
				margin 4px
				padding 8px
				width 144px
				height 64px
				background lighten($theme-color, 95%)
				border-radius 4px

				&, *
					-ms-user-select none
					-moz-user-select none
					-webkit-user-select none
					user-select none
					cursor pointer

				&:hover
					background lighten($theme-color, 90%)

				&:active
					background lighten($theme-color, 85%)

				> .name
					margin 0
					font-size 0.9em
					color darken($theme-color, 30%)

					> i
						margin-right 4px

		> .files
			&:after
				content ""
				display block
				clear both

			> .file
				float left
				margin 4px
				padding 8px 0 0 0
				width 144px
				height 180px
				overflow hidden

				&, *
					-ms-user-select none
					-moz-user-select none
					-webkit-user-select none
					user-select none
					cursor pointer

				&:hover
					background rgba(0, 0, 0, 0.05)

				&:active
					background rgba(0, 0, 0, 0.1)

				&.selected
					background $theme-color

					&:hover
						background lighten($theme-color, 10%)

					&:active
						background darken($theme-color, 10%)

					> .name
						color $theme-color-foreground

				> img
					display block
					margin 0 auto
					pointer-events none

				> .name
					display block
					margin 4px 0 0 0
					font-size 0.8em
					text-align center
					word-break break-all
					color #444

					> .ext
						opacity 0.5

		> .no-files
			padding 16px
			text-align center
			color #888

			> p
				margin 0

		> .loading
			.spinner
				margin 100px auto
				width 40px
				height 40px
				position relative
				text-align center

				-webkit-animation sk-rotate 2.0s infinite linear
				animation sk-rotate 2.0s infinite linear

			.dot1, .dot2
				width 60%
				height 60%
				display inline-block
				position absolute
				top 0
				background-color rgba(0, 0, 0, 0.3)
				border-radius 100%

				-webkit-animation sk-bounce 2.0s infinite ease-in-out
				animation sk-bounce 2.0s infinite ease-in-out

			.dot2
				top auto
				bottom 0
				-webkit-animation-delay -1.0s
				animation-delay -1.0s

			@-webkit-keyframes sk-rotate { 100% { -webkit-transform: rotate(360deg) }}
			@keyframes sk-rotate { 100% { transform: rotate(360deg); -webkit-transform: rotate(360deg) }}

			@-webkit-keyframes sk-bounce {
				0%, 100% { -webkit-transform: scale(0.0) }
				50% { -webkit-transform: scale(1.0) }
			}

			@keyframes sk-bounce {
				0%, 100% {
					transform: scale(0.0);
					-webkit-transform: scale(0.0);
				} 50% {
					transform: scale(1.0);
					-webkit-transform: scale(1.0);
				}
			}

	> mk-uploader
		height 100px
		padding 16px
		background #fff

	> input
		display none

script.
	@mixin \ui

	@files = []
	@folders = []
	@hierarchy-folders = []

	@uploads = []

	# 現在の階層(フォルダ)
	# * null でルートを表す
	@folder = null

	@controller = @opts.controller
	# Note: Riot3.0.0にしたら xmultiple を multiple に変更 (2.xでは、真理値属性と判定され__がプレフィックスされてしまう)
	@multiple = if @opts.xmultiple? then @opts.xmultiple else false

	@uploader-controller = riot.observable!

	@on \mount ~>
		@main.add-event-listener \contextmenu (e) ~>
			e.prevent-default!
			ctx = document.body.append-child document.create-element \mk-drive-browser-base-contextmenu
			ctx-controller = riot.observable!
			riot.mount ctx, do
				controller: ctx-controller
				browser-controller: @controller
			ctx-controller.trigger \open do
				x: e.page-x - window.page-x-offset
				y: e.page-y - window.page-y-offset
		@load!

	@controller.on \upload ~>
		@file-input.click!

	@controller.on \create-folder ~>
		@input-dialog do
			'フォルダー作成'
			'フォルダー名'
			null
			if @opts.is-in-window? then @opts.is-in-window else false
			(name) ~>
				api 'drive/folders/create' do
					name: name
					folder: if @folder? then @folder.id else null
				.then (folder) ~>
					@add-folder folder, true
					@update!
				.catch (err) ~>
					console.error err

	@change-file-input = ~>
		files = @file-input.files
		for i from 0 to files.length - 1
			file = files.item i
			@upload file

	@upload = (file) ~>
		@uploader-controller.trigger do
			\upload
			file
			if @folder == null then null else @folder.id

	@uploader-controller.on \uploaded (file) ~>
		if (file.folder == null and @folder == null) or (file.folder? and @folder? and file.folder == @folder.id)
			@add-file file, true

	@uploader-controller.on \change-uploads (uploads) ~>
		@uploads = uploads
		@update!

	@get-selection = ~>
		@files.filter (file) -> file._selected

	@move = (folder-id) ~>
		if folder-id == null
			@go-root!
		else
			@loading = true
			@update!

			api 'drive/folders/show' do
				folder: folder-id
			.then (folder) ~>
				@folder = folder
				@hierarchy-folders = []
				x = (f) ~>
					f._click = ~>
						@move f.id
					@hierarchy-folders.unshift f
					if f.folder?
						x f.folder
				if folder.folder?
					x folder.folder
				console.log @hierarchy-folders
				@update!
				@load!
			.catch (err, text-status) ->
				console.error err

	@add-folder = (folder, unshift = false) ~>
		folder._title = folder.name

		folder._click = ~>
			@move folder.id

		if unshift
			@folders.unshift folder
		else
			@folders.push folder

		@update!

	@add-file = (file, unshift = false) ~>
		file._title = file.name + '\n' + file.type

		file._click = ~>
			if @multiple
				if file._selected?
					file._selected = !file._selected
				else
					file._selected = true
				@controller.trigger \change-selection @get-selection!
			else
				if file._selected
					@controller.trigger \selected file
				else
					@files.for-each (file) ~>
						file._selected = false
					file._selected = true
					@controller.trigger \change-selection @get-selection!

		if unshift
			@files.unshift file
		else
			@files.push file

		@update!

	@go-root = ~>
		if @folder != null
			@folder = null
			@hierarchy-folders = []
			@update!
			@load!

	@load = ~>
		@folders = []
		@files = []
		@loading = true
		@update!

		api 'drive/folders' do
			folder: if @folder? then @folder.id else null
			limit: 30
		.then (folders) ~>
			folders.for-each (folder) ~>
				@add-folder folder
			@update!
		.catch (err, text-status) ~>
			console.error err

		api 'drive/files' do
			folder: if @folder? then @folder.id else null
			limit: 30
		.then (files) ~>
			files.for-each (file) ~>
				@add-file file
			@update!
		.catch (err, text-status) ~>
			console.error err
		.then ~>
			@loading = false
			@update!
