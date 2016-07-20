mk-header
	div.main: div.container
		div.left
			mk-header-nav
		div.right
			mk-header-search
			mk-header-account(if={SIGNIN})
			mk-header-post-button(if={SIGNIN}, ui={opts.ui})
			mk-header-clock

style.
	position fixed
	top 0
	z-index 1024
	width 100%
	box-shadow 0 0 1px rgba(0, 0, 0, 0)

	> .main
		margin 0
		padding 0
		color $ui-controll-foreground-color
		background #fff
		background-clip content-box
		font-size 0.9rem

		user-select none
		-moz-user-select none
		-webkit-user-select none
		-ms-user-select none
		cursor default

		&:after
			content ""
			display block
			clear both

		> .container
			width 100%
			max-width 1300px
			margin 0 auto

			> .left
				float left
				height 3rem

			> .right
				float right
				height 48px
