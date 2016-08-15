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
	@click = ~>
		@opts.controller.trigger \click

	@opts.controller.on \show ~>
		@root.style.pointer-events = \auto
		Velocity @root, \finish true
		Velocity @root, {
			opacity: 1
		} {
			queue: false
			duration: 100ms
			easing: \linear
		}

	@opts.controller.on \hide ~>
		@root.style.pointer-events = \none
		Velocity @root, \finish true
		Velocity @root, {
			opacity: 0
		} {
			queue: false
			duration: 300ms
			easing: \linear
		}
