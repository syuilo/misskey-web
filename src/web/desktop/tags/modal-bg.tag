mk-modal-bg(onclick={ click })

style.
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

script.
	@controller = @opts.controller

	@mixin \ui

	@click = ~>
		@controller.trigger \click

	@controller.on \show ~>
		@ui.trigger \blur
		@root.style.pointer-events = \auto
		Velocity @root, \finish true
		Velocity @root, {
			opacity: 1
		} {
			queue: false
			duration: 100ms
			easing: \linear
		}

	@controller.on \hide ~>
		@ui.trigger \unblur 300ms
		@root.style.pointer-events = \none
		Velocity @root, \finish true
		Velocity @root, {
			opacity: 0
		} {
			queue: false
			duration: 300ms
			easing: \linear
		}
