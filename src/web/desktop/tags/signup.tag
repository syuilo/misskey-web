mk-signup
	form(onsubmit={ onsubmit }, autocomplete='off')
		button.cancel(type='button', onclick={ cancel }, title='キャンセル'): i.fa.fa-times
		label.username
			p.caption
				i.fa.fa-at
				| ユーザー名
			input(name='username'
				type='text'
				pattern='^[a-zA-Z0-9\-]{3,20}$'
				placeholder='a~z、A~Z、0~9、-'
				autocomplete='off'
				required)
			p.profile-page-url-preview
			p.info(data-state='none')
				i
				span

		label.password
			p.caption
				i.fa.fa-lock
				| パスワード
			input(name='password'
				type='password'
				placeholder='8文字以上を推奨します'
				autocomplete='off'
				required)
			div.meter(data-strength='')
				div.value
			p.info(data-state='none')
				i
				span

		label.retype-password
			p.caption
				i.fa.fa-lock
				| パスワード(再入力)
			input(name='password-retype'
				type='password'
				placeholder='念のため再入力してください'
				autocomplete='off'
				required)
			p.info(data-state='none')
				i
				span

		label.recaptcha
			p.caption
				i.fa.fa-toggle-on(if={ recaptchaed })
				i.fa.fa-toggle-off(if={ !recaptchaed })
				| 認証
			div.g-recaptcha(
				data-callback='onRecaptchaed'
				data-expired-callback='onRecaptchaExpired'
				data-sitekey=CONFIG.recaptcha.siteKey)

		label.agree-tou
			input(
				name='agree-tou',
				type='checkbox',
				autocomplete='off',
				required)
			p
				a() 利用規約
				| に同意する

		mk-ripple-button
			i.fa.fa-check
			span アカウント作成

style.
	display block
	box-sizing border-box
	padding 18px 32px 0 32px
	width 368px
	background #fff
	background-clip padding-box
	border solid 1px rgba(0, 0, 0, 0.1)
	border-radius 4px

	> form
		*:not(i)
			font-family 'Meiryo', 'メイリオ', 'Meiryo UI', sans-serif !important

		&:hover
			> .cancel
				opacity 1

		> .cancel
			appearance none
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
			box-shadow none
			background transparent
			opacity 0
			transition opacity 0.1s ease

			&:hover
				color #555

			&:active
				color #222

			> i
				padding 14px

		label
			display block
			position relative
			margin 16px 0

			> .caption
				margin 0 0 4px 0
				color #828888
				font-size 0.95em

				> i
					margin-right 0.25em
					color #96adac

			> .info
				display block
				margin 4px 0
				font-size 0.8em

				&[data-state='none']
					display none

				&[data-state='error']
					color #FF1161

				&[data-state='processing']
					color #999

				&[data-state='ok']
					color #3CB7B5

				> i
					margin-right 0.3em

			&.username
				.profile-page-url-preview
					display block
					margin 4px 8px 0 4px
					font-size 0.8em
					color #888

					&:empty
						display none

					&:not(:empty) + .info
						margin-top 0

			&.password
				.meter
					display block
					margin-top 8px
					width 100%
					height 8px

					&[data-strength='']
						display none

					&[data-strength='low']
						> .value
							background #d73612

					&[data-strength='medium']
						> .value
							background #d7ca12

					&[data-strength='high']
						> .value
							background #61bb22

					> .value
						display block
						width 0%
						height 100%
						background transparent
						border-radius 4px
						transition all 0.1s ease

		[type=text], [type=password]
			appearance none
			user-select text
			display inline-block
			cursor auto
			box-sizing border-box
			padding 0 12px
			margin 0
			width 100%
			line-height 44px
			font-size 1em
			color #333 !important
			background #fff !important
			outline none
			border solid 1px rgba(0, 0, 0, 0.1)
			border-radius 4px
			box-shadow 0 0 0 114514px #fff inset
			transition all .3s ease
			font-family 'Meiryo', 'メイリオ', 'Meiryo UI', '游ゴシック', 'YuGothic', 'ヒラギノ角ゴ ProN W3', 'Hiragino Kaku Gothic ProN', sans-serif

			&:hover
				border-color rgba(0, 0, 0, 0.2)
				transition all .1s ease

			&:focus
				color $theme-color !important
				border-color $theme-color
				box-shadow 0 0 0 1024px #fff inset, 0 0 0 4px rgba($theme-color, 10%)
				transition all 0s ease

			&:disabled
				opacity 0.5

		.agree-tou
			padding 4px
			border-radius 4px

			&:hover
				background #f4f4f4

			&:active
				background #eee

			&, *
				cursor pointer

			p
				display inline
				color #555

		mk-ripple-button
			margin 20px 0 32px 0
			width 100%
			font-size 1em
			color #fff
			border-radius 3px

script.
	@recaptchaed = false

	window.on-recaptchaed = ~>
		@recaptchaed = true
		@update!

	window.on-recaptcha-expired = ~>
		@recaptchaed = false
		@update!

	@on \mount ~>
		head = (document.get-elements-by-tag-name \head).0
		script = document.create-element \script
			..set-attribute \src \https://www.google.com/recaptcha/api.js
		head.append-child script

	@cancel = ~>
		@opts.oncancel!
