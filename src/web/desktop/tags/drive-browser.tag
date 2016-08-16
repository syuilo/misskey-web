mk-drive-browser
	div.main
		div.folder(each={ folder in folders })
			p { folder.name }
		div.file(each={ file in files })
			img(src={ file.url + '/thumbnail?size=128' }, alt='')
			p.name { file.name }

style.
	display block

	> .main
		box-sizing border-box
		padding 8px
		height 100%
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

			&:hover
				background rgba(0, 0, 0, 0.05)

			> img
				display block
				margin 0 auto

			> .name
				display block
				margin 4px 0 0 0
				font-size 0.8em
				text-align center
				word-break break-all
				color #444

script.
	@files = null
	@folders = null

	# 現在の階層(フォルダ)
	# * null でルートを表す
	@folder = null

	@on \mount ~>
		@load!

	@load = ~>
		api 'drive/files' do
			folder: @folder
		.then (files) ~>
			@files = files
			@update!
		.catch (err, text-status) ->
			console.error err
