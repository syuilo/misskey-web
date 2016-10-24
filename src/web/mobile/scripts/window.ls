riot = require \riot

riot.mixin \window do
	init: ->
		@open = ~>
			@bg.style.pointer-events = \auto
			Velocity @bg, \finish true
			Velocity @bg, {
				opacity: 1
			} {
				queue: false
				duration: 100ms
				easing: \linear
			}

			@body.style.pointer-events = \auto
			Velocity @body, \finish true
			Velocity @body, {scale: 1.1} 0ms
			Velocity @body, {
				opacity: 1
				scale: 1
			} {
				queue: false
				duration: 200ms
				easing: \ease-out
			}

		@close = ~>
			@bg.style.pointer-events = \none
			Velocity @bg, \finish true
			Velocity @bg, {
				opacity: 0
			} {
				queue: false
				duration: 300ms
				easing: \linear
			}

			@body.style.pointer-events = \none
			Velocity @body, \finish true
			Velocity @body, {
				opacity: 0
				scale: 0.8
			} {
				queue: false
				duration: 300ms
				easing: [ 0.5, -0.5, 1, 0.5 ]
			}

			set-timeout ~>
				@unmount!
			, 300ms

		@on \mount ~>
			@open!
