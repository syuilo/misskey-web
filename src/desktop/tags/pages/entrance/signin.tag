mk-entrance-signin
	a.help(href={ CONFIG.urls.about + '/help' }, title='お困りですか？'): i.fa.fa-question
	mk-signin
	div.divider: span or
	button.signup(onclick={ signup }) 新規登録

style.
	display block
	width 290px
	margin 0 auto

	&:hover
		> .help
			opacity 1

	> .help
		cursor pointer
		display block
		position absolute
		top 0
		right 0
		z-index 1
		margin 0
		padding 0
		font-size 1.2em
		color #999
		border none
		outline none
		background transparent
		opacity 0
		transition opacity 0.1s ease

		&:hover
			color #444

		&:active
			color #222

		> i
			padding 14px

	> mk-signin
		padding 10px 28px 0 28px
		background #fff
		box-shadow 0px 4px 16px rgba(0, 0, 0, 0.2)

	> .divider
		padding 16px 0
		text-align center

		&:after
			content ""
			display block
			position absolute
			top 50%
			width 100%
			height 1px
			border-top solid 1px rgba(0, 0, 0, 0.1)

		> *
			z-index 1
			padding 0 8px
			color rgba(0, 0, 0, 0.5)
			background #fdfdfd

	> .signup
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
