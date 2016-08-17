mk-drive-browser
	nav
		ol.path
			li.root(class={ current: folder == null })
				i.fa.fa-cloud
				| ドライブ
			virtual(each={ folder in hierarchy-folders })
				li.separator: i.fa.fa-angle-right
				li.folder
					| { folder.name }
			li.separator(if={ folder != null }): i.fa.fa-angle-right
			li.folder(if={ folder != null })
				| { folder.name }
		input.search(type='search', placeholder!='&#xf002; 検索')
	div.main(class={ uploading: uploads.length > 0 })
		virtual(each={ folder in folders })
			div.folder
				p { folder.name }
		virtual(each={ file in files })
			div.file(class={ selected: file._selected }, onclick={ file._click }, title={ file._title })
				img(src={ file.url + '/thumbnail?size=128' }, alt='')
				p.name
					| { file.name.lastIndexOf('.') != -1 ? file.name.substr(0, file.name.lastIndexOf('.')) : file.name }
					span.ext(if={ file.name.lastIndexOf('.') != -1 }) { file.name.substr(file.name.lastIndexOf('.')) }
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

				i
					margin-right 4px

				&.current
					font-weight bold

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
		box-sizing border-box
		padding 8px
		height calc(100% - 38px)
		overflow auto

		&:after
			content ""
			display block
			clear both

		&.uploading
			height calc(100% - 38px - 100px)

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

	> mk-uploader
		height 100px
		padding 16px
		background #fff

	> input
		display none

script.
	@files = []
	@folders = []

	@uploads = []

	# 現在の階層(フォルダ)
	# * null でルートを表す
	@folder = null

	@controller = @opts.controller
	# Note: Riot3.0.0にしたら xmultiple を multiple に変更 (2.xでは、真理値属性と判定され__がプレフィックスされてしまう)
	@multiple = if @opts.xmultiple? then @opts.xmultiple else false

	@uploader-controller = riot.observable!

	@on \mount ~>
		@load!

	@controller.on \upload ~>
		@file-input.click!

	@change-file-input = ~>
		files = @file-input.files
		for i from 0 to files.length - 1
			file = files.item i
			@upload file

	@upload = (file) ~>
		@uploader-controller.trigger \upload file

	@uploader-controller.on \uploaded (file) ~>
		if (file.folder == null and @folder == null) or (file.folder? and @folder? and file.folder.id == @folder.id)
			@add-file file, true

	@uploader-controller.on \change-uploads (uploads) ~>
		@uploads = uploads
		@update!

	@get-selection = ~>
		@files.filter (file) -> file._selected

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

	@load = ~>
		api 'drive/files' do
			folder: if @folder? then @folder.id else null
			limit: 30
		.then (files) ~>
			files.for-each @add-file
			@update!
		.catch (err, text-status) ->
			console.error err
