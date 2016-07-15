mk-header
	div.main: div.container
		div.left
			mk-header-nav
		div.right
			mk-header-search
			mk-header-account(if={SIGNIN})
			div.post(if={SIGNIN})
				button(onclick={post}, title='新規投稿')
					i.fa.fa-pencil-square-o
			mk-header-clock

script.
	@post = (e) ~>
		@opts.core.trigger \toggle-post-form

style.
	$ui-controll-background-color = #fffbfb
	$ui-controll-foreground-color = #ABA49E

	position fixed
	top 0
	z-index 1024
	width 100%
	box-shadow 0 0 1px rgba(0, 0, 0, 0)

	> .main
		margin 0
		padding 0
		color $ui-controll-foreground-color
		background-color $ui-controll-background-color
		//background-image url("/_resources/common/images/misskey.dark.svg")
		background-repeat no-repeat
		background-position center center
		background-size auto 24px
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

				> .post
					display inline-block
					box-sizing border-box
					padding 8px
					height 100%
					vertical-align top

					> button
						-webkit-appearance none
						-moz-appearance none
						appearance none
						display inline-block
						box-sizing border-box
						margin 0
						padding 0 10px
						height 100%
						font-size 1.2em
						font-weight normal
						text-decoration none
						color $theme-color-foreground
						background $theme-color !important
						outline none
						border none
						border-radius 2px
						box-shadow none
						transition background 0.1s ease
						cursor pointer
						font-family inherit

						*
							pointer-events none

						&:hover
							background lighten($theme-color, 10%) !important

						&:active
							background darken($theme-color, 10%) !important
							transition background 0s ease
