mk-drive-browser-base-contextmenu
	mk-contextmenu(controller={ ctx-controller })
		ul
			li(onclick={ parent.create-folder }): p
				i.fa.fa-folder-o
				| フォルダーを作成
			li(onclick={ parent.upload }): p
				i.fa.fa-upload
				| ファイルをアップロード

script.
	@controller = @opts.controller
	@browser = @opts.browser
	@ctx-controller = riot.observable!

	@controller.on \open (pos) ~>
		@ctx-controller.trigger \open pos

	@ctx-controller.on \closed ~>
		@controller.trigger \closed
		@unmount!

	@create-folder = ~>
		@browser.create-folder!
		@ctx-controller.trigger \close

	@upload = ~>
		@browser.select-local-file!
		@ctx-controller.trigger \close
