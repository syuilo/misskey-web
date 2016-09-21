mk-entrance
	header
		h1@title { title-text }
		mk-kawaii@sub-title
	main@main
		mk-signin@signin-form
		mk-signup@signup-form(oncancel={ signin })
		mk-ripple-button@signup-button(onclick={ signup }) 新規登録

style.
	display block
	padding-bottom 32px

	*:not(i)
		font-family '游ゴシック', 'YuGothic', 'ヒラギノ角ゴ ProN W3', 'Hiragino Kaku Gothic ProN', 'Meiryo', 'メイリオ', 'Meiryo UI', sans-serif !important

	> header
		display block
		position relative
		box-sizing border-box
		padding 64px 32px 64px 32px
		margin 0
		text-align center

		&:before
			content ""
			position absolute
			top 0
			left 0
			z-index 0
			display block
			width 100%
			height 214px
			background linear-gradient(to bottom, rgba(238,238,238,1) 0%,rgba(238,238,238,0) 100%)

		h1
			display block
			position relative
			z-index 1
			margin 0
			padding 0
			font-size 2em
			font-weight normal
			color rgba(0, 0, 0, 0.5)

		mk-kawaii
			display block
			position relative
			z-index 1
			margin 0
			padding 8px 0 0 0
			color rgba(0, 0, 0, 0.4)

	> main
		display block
		position relative
		box-sizing border-box
		width 380px
		margin 0 auto
		padding 32px
		background-image url('/_/resources/desktop/bg.blured.jpg')
		background-attachment fixed
		background-position center
		background-size cover
		background-clip padding-box
		border solid 1px rgba(0, 0, 0, 0.1)
		border-radius 4px

		> mk-signin
			position relative

		> mk-signup
			display none
			position absolute
			top 32px
			left 100%
			opacity 0

		> mk-ripple-button
			margin-top 24px

script.
	@title-text = \Misskey

	@on \mount ~>
		html = (document.get-elements-by-tag-name \html).0
		html.style.background = '#eee'
		html.style.background-image = 'url("/_/resources/desktop/bg.jpg")'
		html.style.background-attachment = \fixed
		html.style.background-position = \center
		html.style.background-size = \cover

	@signup = ~>
		@signup-button.style.pointer-events = \none

		Velocity @signup-button, {
			scale: 0.7
			opacity: 0
		} {
			duration: 500ms
			easing: \ease
		}

		Velocity @title, {
			opacity: 0
		} {
			duration: 500ms
			easing: \ease
			complete: ~>
				@title-text = '始めましょう'
				@update!

				Velocity @sub-title, {
					opacity: 0
				} {
					duration: 500ms
					easing: \ease
				}
		}
		Velocity @title, {
			opacity: 1
		} {
			duration: 500ms
			easing: \ease
		}

		@main.style.height = @main.offset-height + \px
		@main.style.overflow = \hidden

		@signup-form.style.display = \block
		Velocity @signup-form, {
			left: \32px
			opacity: 1
		} {
			duration: 500ms
			easing: \ease
		}

		Velocity @main, {
			width: \434px
		} {
			duration: 500ms
			easing: \ease
		}
		Velocity @main, {
			height: (@signup-form.offset-height + 64px + 2px) + \px
			'margin-top': (-@sub-title.offset-height) + \px
		} {
			duration: 500ms
			easing: \ease
			complete: ~>
				@sub-title.style.display = \none
				@signup-button.style.display = \none
				@signin-form.style.display = \none
				@signup-form.style.position = \relative
				@signup-form.style.top = 0
				@signup-form.style.left = 0
				@main.style.height = \auto
				@main.style.margin-top = 0
				@main.style.overflow = \visible
		}

		Velocity @signin-form, {
			left: \-100%
			opacity: 0
		} {
			duration: 500ms
			easing: \ease
		}

		set-timeout ~>
			#$signup-form.find '.username > input' .focus!
		, 1000ms

	@signin = ~>
		Velocity @title, {
			opacity: 0
		} {
			duration: 500ms
			easing: \ease
			complete: ~>
				@title-text = 'Misskey'
				@update!

				Velocity @sub-title, {
					opacity: 1
				} {
					duration: 500ms
					easing: \ease
				}
		}
		Velocity @title, {
			opacity: 1
		} {
			duration: 500ms
			easing: \ease
		}

		@sub-title.style.display = \block

		@main.style.overflow = \hidden
		@main.style.height = @main.offset-height + \px
		@main.style.margin-top = (-@sub-title.offset-height) + \px

		@signin-form.style.display = \block
		Velocity @signin-form, {
			left: \0px
			opacity: 1
		} {
			duration: 500ms
			easing: \ease
		}

		@signup-button.style.display = \block

		Velocity @main, {
			width: \380px
		} {
			duration: 500ms
			easing: \ease
			complete: ~>
				@main.style.overflow = \visible
		}
		Velocity @main, {
			height: (@signin-form.offset-height + @signup-button.offset-height + 64px + 24px + 2px) + \px
			'margin-top': \0px
		} {
			duration: 500ms
			easing: \ease
			complete: ~>
				@main.style.height = \auto
				@signup-form.style.display = \none
				@signin-form.style.position = \relative
				@signin-form.style.top = 0
				@signin-form.style.left = 0
		}

		@signup-form.style.position = \absolute
		@signup-form.style.top = \32px
		@signup-form.style.left = \32px
		Velocity @signup-form, {
			left: \100%
			opacity: 0
		} {
			duration: 500ms
			easing: \ease
		}

		set-timeout ~>
			@signup-button.style.pointer-events = \auto
			Velocity @signup-button, {
				scale: 1
				opacity: 1
			} {
				duration: 500ms
				easing: \ease
			}
		, 500ms

		set-timeout ~>
			#$signin-form.find '.username > input' .focus!
		, 1000ms
