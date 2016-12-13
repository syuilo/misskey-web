mk-drive-browser-folder-contextmenu
	mk-contextmenu(controller={ ctx-controller }): ul
		li(onclick={ parent.move }): p
			i.fa.fa-arrow-right
			| このフォルダへ移動
		li(onclick={ parent.new-window }): p
			i.fa.fa-share-square-o
			| 新しいウィンドウで表示
		li.separator
		li(onclick={ parent.rename }): p
			i.fa.fa-i-cursor
			| 名前を変更
		li.separator
		li(onclick={ parent.delete }): p
			i.fa.fa-trash-o
			| 削除

script.
	@mixin \api
	@mixin \input-dialog

	@controller = @opts.controller
	@browser = @opts.browser
	@ctx-controller = riot.observable!
	@folder = @opts.folder

	@controller.on \open (pos) ~>
		@ctx-controller.trigger \open pos

	@ctx-controller.on \closed ~>
		@controller.trigger \closed
		@unmount!

	@move = ~>
		@browser.move @folder.id
		@ctx-controller.trigger \close

	@new-window = ~>
		@browser.new-window @folder.id
		@ctx-controller.trigger \close

	@create-folder = ~>
		@browser.create-folder!
		@ctx-controller.trigger \close

	@upload = ~>
		@browser.select-lcoal-file!
		@ctx-controller.trigger \close

	@rename = ~>
		@ctx-controller.trigger \close

		name <~ @input-dialog do
			'フォルダ名の変更'
			'新しいフォルダ名を入力してください'
			@folder.name

		@api \drive/folders/update do
			folder_id: @folder.id
			name: name
		.then ~>
			# something
		.catch (err) ~>
			console.error err
