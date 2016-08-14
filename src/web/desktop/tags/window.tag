mk-window
	header(onmousedown={ on-header-mousedown })
		h1(data-yield='header')
			| <yield from="header"/>
		button.close(title='閉じる', onmousedown={ repel-move }, onclick={ close }): i.fa.fa-times
	div.body(data-yield='content')
		| <yield from="content"/>

style.
	display block
	position fixed
	z-index 2049
	top 15%
	left 0
	width 100%
	max-width 530px
	margin 0
	background #fff
	border-radius 6px
	box-shadow 0 0 8px 0 rgba(0, 0, 0, 0.2)
	overflow hidden
	opacity 0
	pointer-events none

	> header
		cursor move
		background #fff
		background-clip padding-box
		border-bottom solid 1px rgba($theme-color, 0.1)

		> h1
			pointer-events none
			display block
			margin 0
			text-align center
			font-size 1em
			line-height 40px
			font-weight normal
			color #d0b4ac

		> .close
			-webkit-appearance none
			-moz-appearance none
			appearance none
			cursor pointer
			display block
			position absolute
			top 0
			right 0
			z-index 1
			margin 0
			padding 0
			font-size 1.2em
			color rgba($theme-color, 0.4)
			border none
			outline none
			box-shadow none
			background transparent

			&:hover
				color rgba($theme-color, 0.6)

			&:active
				color darken($theme-color, 30%)

			> i
				padding 0
				width 40px
				line-height 40px

	> .body
		position relative

script.
	@is-open = false

	@on \mount ~>
		window.add-event-listener \resize ~>
			position = @form.get-bounding-client-rect!
			browser-width = window.inner-width
			browser-height = window.inner-height
			window-width = @form.offset-width
			window-height = @form.offset-height

			if position.left < 0
				@form.style.left = 0

			if position.top < 0
				@form.style.top = 0

			if position.left + window-width > browser-width
				@form.style.left = browser-width - window-width + \px

			if position.top + window-height > browser-height
				@form.style.top = browser-height - window-height + \px

	@opts.controller.on \toggle ~>
		@toggle!

	@opts.controller.on \open ~>
		@open!

	@opts.controller.on \close ~>
		@close!

	@toggle = ~>
		if @is-open
			@close!
		else
			@open!

	@open = ~>
		@is-open = true
		@opts.controller.trigger \opened

		@root.style.top = \15%
		@root.style.left = (window.inner-width / 2) - (@root.offset-width / 2) + \px

		@root.style.pointer-events = \auto
		Velocity @root, \finish true
		Velocity @root, {scale: 1.2} 0ms
		Velocity @root, {
			opacity: 1
			scale: 1
		} {
			queue: false
			duration: 1000ms
			easing: [ 300, 8 ]
		}

	@close = ~>
		@is-open = false
		@opts.controller.trigger \closed

		@root.style.pointer-events = \none
		Velocity @root, \finish true
		Velocity @root, {
			opacity: 0
			scale: 0.8
		} {
			queue: false
			duration: 300ms
			easing: [ 0.5, -0.5, 1, 0.5 ]
		}

	@repel-move = (e) ~>
		e.stop-propagation!
		return true

	@on-header-mousedown = (e) ~>
		position = @root.get-bounding-client-rect!

		click-x = e.client-x
		click-y = e.client-y
		move-base-x = click-x - position.left
		move-base-y = click-y - position.top
		browser-width = window.inner-width
		browser-height = window.inner-height
		window-width = @root.offset-width
		window-height = @root.offset-height

		mousemove = (me) ~>
			move-left = me.client-x - move-base-x
			move-top = me.client-y - move-base-y

			if move-left < 0
				move-left = 0

			if move-top < 0
				move-top = 0

			if move-left + window-width > browser-width
				move-left = browser-width - window-width

			if move-top + window-height > browser-height
				move-top = browser-height - window-height

			@root.style.left = move-left + \px
			@root.style.top = move-top + \px

		clear = ~>
			window.remove-event-listener \mousemove mousemove
			window.remove-event-listener \mouseup clear
			window.remove-event-listener \mouseleave clear

		window.add-event-listener \mousemove mousemove

		window.add-event-listener \mouseleave clear
		window.add-event-listener \mouseup clear
		window.add-event-listener \dragstart clear
		window.add-event-listener \dragend clear
