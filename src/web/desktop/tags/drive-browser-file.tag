mk-drive-browser-file(data-is-selected={ file._selected }, data-is-contextmenu-showing={ is-contextmenu-showing }, onclick={ onclick }, oncontextmenu={ oncontextmenu }, draggable='true', ondragstart={ ondragstart }, ondragend={ ondragend }, title={ title })
	div.thumbnail: img(src={ file.url + '?thumbnail&size=128' }, alt='')
	p.name
		| { file.name.lastIndexOf('.') != -1 ? file.name.substr(0, file.name.lastIndexOf('.')) : file.name }
		span.ext(if={ file.name.lastIndexOf('.') != -1 }) { file.name.substr(file.name.lastIndexOf('.')) }

style.
	display block
	position relative
	margin 4px
	padding 8px 0 0 0
	width 144px
	height 180px
	border-radius 4px

	&, *
		cursor pointer

	&:hover
		background rgba(0, 0, 0, 0.05)

	&:active
		background rgba(0, 0, 0, 0.1)

	&[data-is-selected]
		background $theme-color

		&:hover
			background lighten($theme-color, 10%)

		&:active
			background darken($theme-color, 10%)

		> .name
			color $theme-color-foreground

	&[data-is-contextmenu-showing]
		&:after
			content ""
			pointer-events none
			position absolute
			top -4px
			right -4px
			bottom -4px
			left -4px
			border 2px dashed rgba($theme-color, 0.3)
			border-radius 4px

	> .thumbnail
		position relative
		width 128px
		height 128px
		left 8px

		> img
			display block
			position absolute
			top 0
			left 0
			right 0
			bottom 0
			margin auto
			pointer-events none

	> .name
		display block
		margin 4px 0 0 0
		font-size 0.8em
		text-align center
		word-break break-all
		color #444
		overflow hidden

		> .ext
			opacity 0.5

script.
	@file = @opts.file
	@browser = @parent

	@title = @file.name + '\n' + @file.type

	@onclick = ~>
		if @browser.multiple
			if @file._selected?
				@file._selected = !@file._selected
			else
				@file._selected = true
			@browser.controller.trigger \change-selection @browser.get-selection!
		else
			if @file._selected
				@browser.controller.trigger \selected file
			else
				@browser.files.for-each (file) ~>
					file._selected = false
				@file._selected = true
				@browser.controller.trigger \change-selection @browser.get-selection!

	@oncontextmenu = (e) ~>
		e.stop-immediate-propagation!
		@is-contextmenu-showing = true
		@update!
		ctx = document.body.append-child document.create-element \mk-drive-browser-file-contextmenu
		ctx-controller = riot.observable!
		riot.mount ctx, do
			controller: ctx-controller
			browser-controller: @browser.controller
			file: @file
		ctx-controller.trigger \open do
			x: e.page-x - window.page-x-offset
			y: e.page-y - window.page-y-offset
		ctx-controller.on \closed ~>
			@is-contextmenu-showing = false
			@update!
		return false

	@ondragstart = (e) ~>
		e.data-transfer.effect-allowed = \move
		e.data-transfer.set-data 'text' JSON.stringify do
			type: \file
			id: @file.id
		@is-dragging = true

	@ondragend = (e) ~>
		@is-dragging = false
