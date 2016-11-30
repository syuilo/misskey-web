mk-entrance
	main
		h1 Misskey

		div.form
			mk-entrance-signin(if={ mode == 'signin' }, onsignup={ signup })
			mk-entrance-signup(if={ mode == 'signup' }, onsignin={ signin })

	footer
		mk-copyright

style.
	display block
	height 100%

	> main
		display block

		> h1
			margin 0
			padding 32px 0
			text-align center
			font-size 18px
			color #555

	> footer
		> mk-copyright
			margin 0
			text-align center
			line-height 64px
			font-size 10px
			color rgba(#000, 0.5)

script.
	@mode = \signin

	@signup = ~>
		@mode = \signup
		@update!

	@signin = ~>
		@mode = \signin
		@update!
