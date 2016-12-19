mk-entrance
	main
		img(src='/_/resources/title.svg', alt='Misskey')

		div.form
			mk-entrance-signin(if={ mode == 'signin' }, onsignup={ signup })
			mk-entrance-signup(if={ mode == 'signup' }, onsignin={ signin })

	mk-forkit

	footer
		mk-copyright

style.
	display block
	height 100%

	> main
		display block

		> img
			display block
			width 160px
			height 170px
			margin 0 auto
			pointer-events none
			user-select none

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
