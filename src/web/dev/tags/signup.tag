mk-new-app
	form(onsubmit={ onsubmit }, autocomplete='off')
		label.nid
			p.caption
				i.fa.fa-at
				| Name ID
			input@nid(
				type='text'
				pattern='^[a-zA-Z0-9\-]{3,20}$'
				placeholder='a~z、A~Z、0~9、-'
				autocomplete='off'
				required
				onkeyup={ on-change-nid })

			p.info(if={ nid-state == 'wait' }, style='color:#999')
				i.fa.fa-fw.fa-spinner.fa-pulse
				| 確認しています...
			p.info(if={ nid-state == 'ok' }, style='color:#3CB7B5')
				i.fa.fa-fw.fa-check
				| 利用できます
			p.info(if={ nid-state == 'unavailable' }, style='color:#FF1161')
				i.fa.fa-fw.fa-exclamation-triangle
				| 既に利用されています
			p.info(if={ nid-state == 'error' }, style='color:#FF1161')
				i.fa.fa-fw.fa-exclamation-triangle
				| 通信エラー
			p.info(if={ nid-state == 'invalid-format' }, style='color:#FF1161')
				i.fa.fa-fw.fa-exclamation-triangle
				| a~z、A~Z、0~9、-(ハイフン)が使えます
			p.info(if={ nid-state == 'min-range' }, style='color:#FF1161')
				i.fa.fa-fw.fa-exclamation-triangle
				| 3文字以上でお願いします！
			p.info(if={ nid-state == 'max-range' }, style='color:#FF1161')
				i.fa.fa-fw.fa-exclamation-triangle
				| 20文字以内でお願いします

		button(onclick={ onsubmit })
			| アプリ作成

style.
	display block
	box-sizing border-box
	padding 18px 32px 0 32px
	min-width 368px
	overflow hidden

	> form
		*:not(i)
			font-family 'Meiryo', 'メイリオ', 'Meiryo UI', sans-serif !important

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

				> i
					margin-right 0.3em

		[type=text]
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

		> button
			margin 20px 0 32px 0
			width 100%
			font-size 1em
			color #fff
			border-radius 3px

script.
	@mixin \api

	@nid-state = null

	@on-change-nid = ~>
		nid = @nid.value

		if nid == ''
			@nid-state = null
			@update!
			return

		err = switch
			| not nid.match /^[a-zA-Z0-9\-]+$/ => \invalid-format
			| nid.length < 3chars              => \min-range
			| nid.length > 20chars             => \max-range
			| _                                     => null

		if err?
			@nid-state = err
			@update!
		else
			@nid-state = \wait
			@update!

			@api \app/name_id/available do
				name_id: nid
			.then (result) ~>
				if result.available
					@nid-state = \ok
				else
					@nid-state = \unavailable
				@update!
			.catch (err) ~>
				@nid-state = \error
				@update!

	@onsubmit = ~>
		nid = @nid.value
		password = @password.value

		locker = document.body.append-child document.create-element \mk-locker

		@api \app/create do
			name_id: nid
			password: password
		.then ~>
			location.href = CONFIG.url
		.catch ~>
			alert 'アプリの作成に失敗しました。再度お試しください。'

			locker.parent-node.remove-child locker
