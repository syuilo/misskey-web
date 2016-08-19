mk-drive-browser-nav-folder(data-draghover={ draghover }, onclick={ onclick }, ondragover={ ondragover }, ondragenter={ ondragenter }, ondragleave={ ondragleave }, ondrop={ ondrop })
	i.fa.fa-cloud(if={ folder == null })
	span { folder == null ? 'ドライブ' : folder.name }

style.
	&[data-draghover]
		background #eee

script.
	@folder = @opts.folder
	@browser = @parent

	@hover = false

	@onclick = ~>
		@browser.move @folder

	@onmouseover = ~>
		@hover = true

	@onmouseout = ~>
		@hover = false

	@ondragover = (e) ~>
		e.stop-propagation!
		# ドラッグされてきたものがファイルだったら
		if e.data-transfer.effect-allowed == \all
			e.data-transfer.drop-effect = \copy
		else
			e.data-transfer.drop-effect = \move
		return false

	@ondragenter = ~>
		@draghover = true

	@ondragleave = ~>
		@draghover = false

	@ondrop = (e) ~>
		e.stop-propagation!
		@draghover = false

		# ファイルだったら
		if e.data-transfer.files.length > 0
			Array.prototype.for-each.call e.data-transfer.files, (file) ~>
				@browser.upload file, @folder
			return false

		# データ取得
		data = e.data-transfer.get-data 'text'
		if !data?
			return false

		# パース
		obj = JSON.parse data

		# (ドライブの)ファイルだったら
		if obj.type == \file
			file = obj.id
			@browser.remove-file file
			api 'drive/files/update' do
				file: file
				folder: if @folder? then @folder.id else null
			.then ~>
				# something
			.catch (err, text-status) ~>
				console.error err

		# (ドライブの)フォルダーだったら
		else if obj.type == \folder
			folder = obj.id
			# 移動先が自分自身ならreject
			if @folder? and folder == @folder.id
				return false
			@browser.remove-folder folder
			api 'drive/folders/update' do
				folder: folder
				parent: if @folder? then @folder.id else null
			.then ~>
				# something
			.catch (err, text-status) ~>
				console.error err

		return false
