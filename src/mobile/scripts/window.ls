riot = require \riot

duration = 500ms
easing = [0 0.7 0 1]

riot.mixin \window do
	init: ->
		@open = ~>
			@refs.bg.style.pointer-events = \auto
			Velocity @refs.bg, {
				opacity: 1
			} {
				duration: duration
				easing: \linear
			}

			@refs.body.style.pointer-events = \auto
			Velocity @refs.body, { top: window.inner-height + \px } 0ms
			Velocity @refs.body, {
				top: \16px
			} {
				duration: duration
				easing: easing
			}

		@close = ~>
			@refs.bg.style.pointer-events = \none
			Velocity @refs.bg, {
				opacity: 0
			} {
				duration: duration
				easing: \linear
			}

			@refs.body.style.pointer-events = \none
			Velocity @refs.body, {
				top: window.inner-height + \px
			} {
				duration: duration
				easing: easing
			}

			set-timeout ~>
				@unmount!
			, duration

		@on \mount ~>
			@open!
