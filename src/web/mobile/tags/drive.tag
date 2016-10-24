mk-drive
	nav
		p(onclick={ go-root })
			i.fa.fa-cloud
			| ドライブ
		virtual(each={ folder in hierarchy-folders })
			span: i.fa.fa-angle-right
			p(onclick={ _move }) { folder.name }
		span(if={ folder != null }): i.fa.fa-angle-right
		p(if={ folder != null }) { folder.name }
	div.main(class={ loading: loading })
		div.folders@folders-container(if={ folders.length > 0 })
			virtual(each={ folder in folders })
				mk-drive-folder(folder={ folder })
			p(if={ more-folders })
				| もっと読み込む
		div.files@files-container(if={ files.length > 0 })
			virtual(each={ file in files })
				mk-drive-file(file={ file })
			p(if={ more-files })
				| もっと読み込む
		div.empty(if={ files.length == 0 && folders.length == 0 && !loading })
			p(if={ !folder == null })
				| ドライブには何もありません。
			p(if={ folder != null })
				| このフォルダーは空です
		div.loading(if={ loading }).
			<div class="spinner">
				<div class="dot1"></div>
				<div class="dot2"></div>
			</div>

style.

	> nav
		display block
		box-sizing border-box
		width 100%
		padding 10px 12px
		overflow auto
		white-space nowrap
		font-size 0.9em
		color #555
		background #fff
		border-bottom solid 1px #dfdfdf

		> p
			display inline
			margin 0
			padding 0

			&:last-child
				font-weight bold

			> i
				margin-right 4px

		> span
			margin 0 8px
			opacity 0.5

	> .main
		&.loading
			opacity 0.5

		> .folders
			> mk-drive-folder
				border-bottom solid 1px #eee

		> .files
			> mk-drive-file
				border-bottom solid 1px #eee

script.
	@mixin \api
	@mixin \stream

	@files = []
	@folders = []
	@hierarchy-folders = []

	# 現在の階層(フォルダ)
	# * null でルートを表す
	@folder = null

	@event = @opts.event
	# Note: Riot3.0.0にしたら xmultiple を multiple に変更 (2.xでは、真理値属性と判定され__がプレフィックスされてしまう)
	@multiple = if @opts.xmultiple? then @opts.xmultiple else false

	@on \mount ~>
		@stream.on \drive_file_created @on-stream-drive-file-created
		@stream.on \drive_file_updated @on-stream-drive-file-updated
		@stream.on \drive_folder_created @on-stream-drive-folder-created
		@stream.on \drive_folder_updated @on-stream-drive-folder-updated

		if @opts.folder?
			@move @opts.folder
		else
			@load!

	@on \unmount ~>
		@stream.off \drive_file_created @on-stream-drive-file-created
		@stream.off \drive_file_updated @on-stream-drive-file-updated
		@stream.off \drive_folder_created @on-stream-drive-folder-created
		@stream.off \drive_folder_updated @on-stream-drive-folder-updated

	@on-stream-drive-file-created = (file) ~>
		@add-file file, true

	@on-stream-drive-file-updated = (file) ~>
		current = if @folder? then @folder.id else null
		updated-file-parent = if file.folder? then file.folder else null
		if current != updated-file-parent
			@remove-file file
		else
			@add-file file, true

	@on-stream-drive-folder-created = (folder) ~>
		@add-folder folder, true

	@on-stream-drive-folder-updated = (folder) ~>
		current = if @folder? then @folder.id else null
		updated-folder-parent = if folder.folder? then folder.folder else null
		if current != updated-folder-parent
			@remove-folder folder
		else
			@add-folder folder, true

	@get-selection = ~>
		@files.filter (file) -> file._selected

	@_move = (ev) ~>
		@move ev.item.folder

	@move = (target-folder) ~>
		if target-folder? and typeof target-folder == \object
			target-folder = target-folder.id

		if target-folder == null
			@go-root!
			return

		@loading = true
		@update!

		@api \drive/folders/show do
			folder: target-folder
		.then (folder) ~>
			@folder = folder
			@hierarchy-folders = []

			x = (f) ~>
				@hierarchy-folders.unshift f
				if f.folder?
					x f.folder

			if folder.folder?
				x folder.folder

			@update!
			@load!
		.catch (err, text-status) ->
			console.error err

	@add-folder = (folder, unshift = false) ~>
		current = if @folder? then @folder.id else null
		addee-parent = if folder.folder? then folder.folder else null
		if current != addee-parent
			return

		if (@folders.some (f) ~> f.id == folder.id)
			return

		if unshift
			@folders.unshift folder
		else
			@folders.push folder

		@update!

	@add-file = (file, unshift = false) ~>
		current = if @folder? then @folder.id else null
		addee-parent = if file.folder? then file.folder else null
		if current != addee-parent
			return

		if (@files.some (f) ~> f.id == file.id)
			# TODO: ただreturnするのではなく情報を更新する
			return

		if unshift
			@files.unshift file
		else
			@files.push file

		@update!

	@remove-folder = (folder) ~>
		if typeof folder == \object
			folder = folder.id
		@folders = @folders.filter (f) -> f.id != folder
		@update!

	@remove-file = (file) ~>
		if typeof file == \object
			file = file.id
		@files = @files.filter (f) -> f.id != file
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
		@more-folders = false
		@more-files = false
		@loading = true
		@update!

		@event.trigger \begin-load

		load-folders = null
		load-files = null

		folders-max = 20
		files-max = 20

		# フォルダ一覧取得
		@api \drive/folders do
			folder: if @folder? then @folder.id else null
			limit: folders-max + 1
		.then (folders) ~>
			if folders.length == folders-max + 1
				@more-folders = true
				folders.pop!
			load-folders := folders
			complete!
		.catch (err, text-status) ~>
			console.error err

		# ファイル一覧取得
		@api \drive/files do
			folder: if @folder? then @folder.id else null
			limit: files-max + 1
		.then (files) ~>
			if files.length == files-max + 1
				@more-files = true
				files.pop!
			load-files := files
			complete!
		.catch (err, text-status) ~>
			console.error err

		flag = false
		complete = ~>
			if flag
				load-folders.for-each (folder) ~>
					@add-folder folder
				load-files.for-each (file) ~>
					@add-file file
				@loading = false
				@update!

				@event.trigger \loaded
			else
				flag := true
				@event.trigger \load-mid
