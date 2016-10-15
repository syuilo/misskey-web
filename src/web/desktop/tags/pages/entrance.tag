mk-entrance
	main@main
		div.title
			div m
			div i
			div s
			div s
			div k
			div e
			div y
			div
			div: i ・
			div: i ・
			div
			div
			div: i ・
			div
			div
			div

		div.form
			mk-signin
			p or
			mk-ripple-button.signup(onclick={ signup }) 新規登録

style.
	display block
	height 100%
	background #fdfdfd
	box-shadow 0 0 0 114514px #eee
	border-top solid 64px #fff

	*:not(i)
		font-family '游ゴシック', 'YuGothic', 'ヒラギノ角ゴ ProN W3', 'Hiragino Kaku Gothic ProN', 'Meiryo', 'メイリオ', 'Meiryo UI', sans-serif !important

	> main
		display block
		position relative
		width 624px
		margin 0 auto
		padding 128px 0 32px 0

		> .title
			$tile = 52px

			width $tile * 4
			font-size ($tile / 3)
			color #555

			&:after
				content ''
				display block
				clear both

			> div
				float left
				width $tile
				height $tile
				line-height $tile
				text-align center

				&:hover
					background #fff

				&:first-child
					color $theme-color-foreground
					background $theme-color !important

				&:nth-child(5)
					color #fff
					background #444

				> i
					font-style normal
					opacity 0.5

		> .form
			position absolute
			top 128px
			right 0
			width 300px
			background #eee
			border solid 8px #eee
			border-radius 6px

			> p
				display block
				margin 8px 0
				text-align center
				line-height 32px
				color #888

script.

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
