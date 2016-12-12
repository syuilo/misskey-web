mk-ui-notification
	p { opts.message }

style.
	display block
	position fixed
	z-index 10000
	top -64px
	left 0
	right 0
	margin 0 auto
	width 500px
	color #fff
	background rgba(#000, 0.7)
	border-radius 0 0 4px 4px

	> p
		margin 0
		line-height 64px
		text-align center

script.
	@on \mount ~>
		Velocity @root, {
			top: \0px
		} {
			duration: 500ms
			easing: \ease-out
		}

		set-timeout ~>
			Velocity @root, {
				top: \-64px
			} {
				duration: 500ms
				easing: \ease-out
				complete: ~>
					@unmount!
			}
		, 6000ms
