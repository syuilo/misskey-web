mk-window
	div.bg@bg(show={ is-modal }, onclick={ bg-click })
	div.main@main
		header(onmousedown={ on-header-mousedown })
			h1(data-yield='header')
				| <yield from="header"/>
			button.close(if={ can-close }, onmousedown={ repel-move }, onclick={ close }, title='閉じる'): i.fa.fa-times
		div.body(data-yield='content')
			| <yield from="content"/>

style.
	> .bg
		display block
		position fixed
		z-index 2048
		top 0
		left 0
		width 100%
		height 100%
		background rgba(0, 0, 0, 0.7)
		opacity 0
		pointer-events none

	> .main
		display block
		position fixed
		z-index 2048
		top 15%
		left 0
		width 100%
		max-width 530px
		margin 0
		background #fff
		border-radius 6px
		box-shadow 0 2px 6px 0 rgba(0, 0, 0, 0.2)
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
	@mixin \ui

	@is-open = false
	@is-modal = if opts.is-modal? then opts.is-modal else false
	@can-close = if opts.can-close? then opts.can-close else true

	@controller = @opts.controller

	@on \mount ~>
		window.add-event-listener \resize ~>
			position = @main.get-bounding-client-rect!
			browser-width = window.inner-width
			browser-height = window.inner-height
			window-width = @main.offset-width
			window-height = @main.offset-height

			if position.left < 0
				@main.style.left = 0

			if position.top < 0
				@main.style.top = 0

			if position.left + window-width > browser-width
				@main.style.left = browser-width - window-width + \px

			if position.top + window-height > browser-height
				@main.style.top = browser-height - window-height + \px

	@controller.on \toggle ~>
		@toggle!

	@controller.on \open ~>
		@open!

	@controller.on \close ~>
		@close!

	@toggle = ~>
		if @is-open
			@close!
		else
			@open!

	@open = ~>
		@is-open = true
		@controller.trigger \opened

		@main.style.top = \15%
		@main.style.left = (window.inner-width / 2) - (@main.offset-width / 2) + \px

		if @is-modal
			@ui.trigger \blur
			@bg.style.pointer-events = \auto
			Velocity @bg, \finish true
			Velocity @bg, {
				opacity: 1
			} {
				queue: false
				duration: 100ms
				easing: \linear
			}

		@main.style.pointer-events = \auto
		Velocity @main, \finish true
		Velocity @main, {scale: 1.2} 0ms
		Velocity @main, {
			opacity: 1
			scale: 1
		} {
			queue: false
			duration: 1000ms
			easing: [ 300, 8 ]
		}

	@close = ~>
		@is-open = false
		@controller.trigger \closed

		if @is-modal
			@ui.trigger \unblur 300ms
			@bg.style.pointer-events = \none
			Velocity @bg, \finish true
			Velocity @bg, {
				opacity: 0
			} {
				queue: false
				duration: 300ms
				easing: \linear
			}

		@main.style.pointer-events = \none
		Velocity @main, \finish true
		Velocity @main, {
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

	@bg-click = ~>
		if @can-close
			@close!

	@on-header-mousedown = (e) ~>
		position = @main.get-bounding-client-rect!

		click-x = e.client-x
		click-y = e.client-y
		move-base-x = click-x - position.left
		move-base-y = click-y - position.top
		browser-width = window.inner-width
		browser-height = window.inner-height
		window-width = @main.offset-width
		window-height = @main.offset-height

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

			@main.style.left = move-left + \px
			@main.style.top = move-top + \px

		clear = ~>
			window.remove-event-listener \mousemove mousemove
			window.remove-event-listener \mouseup clear
			window.remove-event-listener \mouseleave clear

		window.add-event-listener \mousemove mousemove

		window.add-event-listener \mouseleave clear
		window.add-event-listener \mouseup clear
		window.add-event-listener \dragstart clear
		window.add-event-listener \dragend clear
