mk-select-file-from-drive-window
	mk-window(controller={ opts.controller }, is-modal={ true })
		<yield to="header">
		i.fa.fa-file-o
		| ファイルを選択
		</yield>
		<yield to="content">
		mk-drive-browser
		</yield>

script.
	@cancel = ~>
		@opts.controller.trigger \close

	@ok = ~>
		# something
