mk-drive-browser-file-contextmenu
	mk-contextmenu(controller={ ctx-controller })
		ul
			li(onclick={ parent.rename }): p
				i.fa.fa-i-cursor
				| 名前を変更
			li(onclick={ parent.copy-url }): p
				i.fa.fa-link
				| URLをコピー
			li: a(href={ parent.file.url + '?download' }, download={ parent.file.name }, onclick={ parent.download })
				i.fa.fa-download
				| ダウンロード
		ul
			li(onclick={ parent.delete }): p
				i.fa.fa-trash-o
				| 削除
		ul
			li(onclick={ parent.create-folder }): p
				i.fa.fa-folder-o
				| フォルダーを作成
			li(onclick={ parent.upload }): p
				i.fa.fa-upload
				| ファイルをアップロード

script.
	@mixin \NotImplementedException

	@controller = @opts.controller
	@browser-controller = @opts.browser-controller
	@ctx-controller = riot.observable!
	@file = @opts.file

	@controller.on \open (pos) ~>
		@ctx-controller.trigger \open pos

	@ctx-controller.on \closed ~>
		@controller.trigger \closed
		@unmount!
	
	@copy-url = ~>
		@NotImplementedException!

	@download = ~>
		#@browser-controller.trigger \download @file
		@ctx-controller.trigger \close
		return true

	@create-folder = ~>
		@browser-controller.trigger \create-folder
		@ctx-controller.trigger \close

	@upload = ~>
		@browser-controller.trigger \upload
		@ctx-controller.trigger \close
