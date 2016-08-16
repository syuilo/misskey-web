mk-select-file-from-drive-window
	mk-window(controller={ opts.controller }, is-modal={ true }, is-child={ opts.is-child }, width={ '700px' }, height={ '400px' })
		<yield to="header">
		i.fa.fa-file-o
		| ファイルを選択
		</yield>
		<yield to="content">
		mk-drive-browser
		</yield>

style.
	> mk-window
		[data-yield='content']
			> mk-drive-browser
				height 100%

script.
	@cancel = ~>
		@opts.controller.trigger \close

	@ok = ~>
		# something
