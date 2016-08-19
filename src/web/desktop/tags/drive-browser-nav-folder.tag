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
		else
			file = e.data-transfer.get-data 'text'
			if !file?
				return false

			@browser.remove-file file

			api 'drive/files/update' do
				file: file
				folder: if @folder? then @folder.id else null
			.then ~>
				# something
			.catch (err, text-status) ~>
				console.error err

		return false
