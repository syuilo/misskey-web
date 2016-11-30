mk-entrance-signin
	mk-signin
	button.signup(onclick={ signup }) 新規登録

style.
	display block
	margin 0 auto
	padding 0 8px
	max-width 350px

	> .signup
		margin-top 16px
		padding 16px
		width 100%
		font-size 1em
		color #fff
		background $theme-color
		border-radius 3px

		&:hover
			background lighten($theme-color, 5%)

		&:active
			background darken($theme-color, 5%)

script.
	@signup = ~>
		@opts.onsignup!
