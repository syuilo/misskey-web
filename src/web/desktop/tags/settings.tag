mk-settings
	div.nav
		a アカウント
	div.pages
		div(show={ page == 'account' })
			h1 アカウント
			button(onclick={ avatar }) アバター選択

style.
	display block

	> .nav
		position absolute
		top 0
		left 0
		width 200px

	> .pages
		position absolute
		top 0
		left 200px
		width calc(100% - 200px)

script.
	@page = \account

	@avatar = ~>
		browser = document.body.append-child document.create-element \mk-select-file-from-drive-window
		browser-controller = riot.observable!
		riot.mount browser, do
			multiple: false
			controller: browser-controller
		browser-controller.trigger \open
		browser-controller.one \selected (file) ~>
			cropper = document.body.append-child document.create-element \mk-crop-window
			cropper-controller = riot.observable!
			riot.mount cropper, do
				file: file
				title: 'アバターとして表示する部分を選択'
				controller: cropper-controller
			cropper-controller.trigger \open
			cropper-controller.on \cropped (blob) ~>
				data = new FormData!
				data.append \_i USER._web
				data.append \file blob, file.name + '.cropped.png'
				api 'drive/folders/find' do
					name: 'アイコン'
				.then (icon-folder) ~>
					if icon-folder.length == 0
						api 'drive/folders/create' do
							name: 'アイコン'
						.then (icon-folder) ~>
							@avatar-uplaod data, icon-folder
					else
						@avatar-uplaod data, icon-folder.0

		@avatar-uplaod = (data, folder) ~>

			if folder?
				data.append \folder folder.id

			xhr = new XMLHttpRequest!
			xhr.open \POST CONFIG.api.url + '/drive/files/create' true
			xhr.onload = (e) ~>
				file = JSON.parse e.target.response

				api 'i/update' do
					avatar: file.id
				.then (data) ~>
					# something
				.catch (err) ~>
					console.error err
					#@opts.ui.trigger \notification 'Error!'

			#xhr.upload.onprogress = (e) ~>
			#	if e.length-computable
			#		if ctx.progress == undefined
			#			ctx.progress = {}
			#		ctx.progress.max = e.total
			#		ctx.progress.value = e.loaded
			#		@update!

			xhr.send data
