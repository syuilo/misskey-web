mk-drive-browser
	nav
		ol
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
	div.main
		virtual(each={ folder in folders })
			div.folder
				p { folder.name }
		virtual(each={ file in files })
			div.file(class={ selected: file._selected }, onclick={ file._click }, title={ file._title })
				img(src={ file.url + '/thumbnail?size=128' }, alt='')
				p.name
					| { file.name.lastIndexOf('.') != -1 ? file.name.substr(0, file.name.lastIndexOf('.')) : file.name }
					span.ext(if={ file.name.lastIndexOf('.') != -1 }) { file.name.substr(file.name.lastIndexOf('.')) }

style.
	display block

	> nav
		display block
		position relative
		box-sizing border-box
		padding 0 12px
		width 100%
		overflow auto
		font-size 0.9em
		color #555
		background #fff
		//border-bottom 1px solid #dfdfdf
		box-shadow 0 1px 0 rgba(0, 0, 0, 0.05)

		> ol
			display block
			margin 0
			padding 0
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

	> .main
		box-sizing border-box
		padding 8px
		height calc(100% - 38px)
		overflow auto

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

script.
	@files = []
	@folders = []

	# 現在の階層(フォルダ)
	# * null でルートを表す
	@folder = null

	@controller = @opts.controller
	# Note: Riot3.0.0にしたら xmultiple を multiple に変更 (2.xでは、真理値属性と判定され__がプレフィックスされてしまう)
	@multiple = if @opts.xmultiple? then @opts.xmultiple else false

	@on \mount ~>
		@load!

	@get-selection = ~>
		@files.filter (file) -> file._selected

	@add-file = (file) ~>
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

		@files.push file

	@load = ~>
		api 'drive/files' do
			folder: if @folder? then @folder.id else null
			limit: 30
		.then (files) ~>
			files.for-each @add-file
			@update!
		.catch (err, text-status) ->
			console.error err
