mk-ui-header
	div.backdrop
	div.main: div.container
		div.left
			mk-header-nav
		div.right
			mk-header-search
			mk-header-account(if={SIGNIN})
			mk-header-notifications(if={SIGNIN})
			mk-header-post-button(if={SIGNIN}, ui={opts.ui})
			mk-header-clock

style.
	position fixed
	top 0
	z-index 1024
	width 100%
	box-shadow 0 1px 0 rgba(0, 0, 0, 0.075)

	> .backdrop
		position fixed
		top 0
		z-index 1023
		width 100%
		height 48px
		backdrop-filter blur(12px)
		//background-color rgba(255, 255, 255, 0.75)
		background #fff

	> .main
		position relative
		z-index 1024
		margin 0
		padding 0
		color $ui-controll-foreground-color
		background-clip content-box
		font-size 0.9rem

		user-select none
		-moz-user-select none
		-webkit-user-select none
		-ms-user-select none
		cursor default

		> .container
			width 100%
			max-width 1300px
			margin 0 auto

			&:after
				content ""
				display block
				clear both

			> .left
				float left
				height 3rem

			> .right
				float right
				height 48px
