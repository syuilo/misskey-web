mk-post-form
	div@bg
	div@container(onclick={ close }): form@form(onclick={ repel-close }, class={ wait: wait })
		h1 新規投稿
		button.close(title='キャンセル', onclick={ close }): i.fa.fa-times
		div.body
			textarea@text(disabled={ wait }, placeholder='いまどうしてる？')
			ul.files
				li(each={ files })
			ul.uploadings
				li(each={ uploadings })
					div.img(style='background-image: url({ img })', alt='')
					p.name
						i.fa.fa-spinner.fa-pulse
						| { name }
					p.status
						span.initing(if={ progress == undefined }) 待機中...
						span.kb(if={ progress != undefined })
							| { String(Math.floor(progress.value / 1024)).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1,') }
							i KB
							= ' / '
							| { String(Math.floor(progress.max / 1024)).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1,') }
							i KB
						span.percentage(if={ progress != undefined }) { Math.floor((progress.value / progress.max) * 100) }
					progress(if={ progress != undefined && progress.value != progress.max }, value={ progress.value }, max={ progress.max })
					div.progress.initing(if={ progress == undefined })
					div.progress.waiting(if={ progress.value == progress.max })
			button@upload(title='PCからファイルを添付', onclick={ select-file }): i.fa.fa-upload
			button@drive(title='ドライブからファイルを添付', onclick={ drive }): i.fa.fa-cloud
			button@submit(disabled={ wait }, onclick={ post }) { wait ? '送信中...' : '投稿' }
			input@file(type='file', accept='image/*', multiple, tabindex='-1', onchange={ change-file })

style.
	[name='bg']
	[name='container']
		display block
		position fixed
		top 0
		width 100%
		height 100%
		pointer-events none

	[name='bg']
		z-index 2048
		left 0
		background rgba(0, 0, 0, 0.7)
		opacity 0

	[name='container']
		z-index 2049

	[name='form']
		display block
		position absolute
		top 15%
		right 0
		left 0
		width 100%
		max-width 530px
		margin auto
		background #fff
		border-radius 6px
		overflow hidden
		opacity 0

		&.wait
			&, *
				cursor wait !important

			[name='submit']
				background linear-gradient(
					45deg,
					darken($theme-color, 10%) 25%,
					$theme-color              25%,
					$theme-color              50%,
					darken($theme-color, 10%) 50%,
					darken($theme-color, 10%) 75%,
					$theme-color              75%,
					$theme-color
				)
				background-size 32px 32px
				animation stripe-bg 1.5s linear infinite
				opacity 0.7

				@keyframes stripe-bg
					from {background-position: 0 0;}
					to   {background-position: -64px 32px;}

		h1
			user-select none
			-webkit-user-select none
			-moz-user-select none
			display block
			margin 0
			text-align center
			font-size 1.1em
			line-height 40px
			font-weight normal
			color #d0b4ac
			background #fff
			background-clip padding-box
			border-bottom solid 1px rgba($theme-color, 0.1)

		.close
			-webkit-appearance none
			-moz-appearance none
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
			color rgba($theme-color, 0.4)
			border none
			outline none
			box-shadow none
			background transparent

			&:hover
				color rgba($theme-color, 0.6)

			&:active
				color darken($theme-color, 30%)

			> i
				padding 0
				width 40px
				line-height 40px

		.body
			position relative
			padding 16px
			background lighten($theme-color, 95%)

			&:after
				content ""
				display block
				clear both

	.uploadings
		margin 8px 0 0 0
		padding 8px
		border solid 1px rgba($theme-color, 0.1)
		border-radius 4px
		list-style none

		&:empty
			display none

		> li
			display block
			position relative
			margin 8px 0 0 0
			padding 0
			height 36px
			box-shadow 0 -1px 0 rgba($theme-color, 0.1)
			border-top solid 8px transparent

			&:first-child
				margin 0
				box-shadow none
				border-top none

			> .img
				display block
				position absolute
				top 0
				left 0
				width 36px
				height 36px
				background-size cover
				background-position center center

			> .name
				display block
				position absolute
				top 0
				left 44px
				margin 0
				padding 0
				max-width 256px
				font-size 0.8em
				color rgba($theme-color, 0.7)
				white-space nowrap
				text-overflow ellipsis
				overflow hidden

				> i
					margin-right 4px

			> .status
				display block
				position absolute
				top 0
				right 0
				margin 0
				padding 0
				font-size 0.8em

				> .initing
					color rgba($theme-color, 0.5)

				> .kb
					color rgba($theme-color, 0.5)

				> .percentage
					display inline-block
					width 48px
					text-align right

					color rgba($theme-color, 0.7)

					&:after
						content '%'

			> progress
				-webkit-appearance none
				-moz-appearance none
				appearance none
				display block
				position absolute
				bottom 0
				right 0
				margin 0
				width calc(100% - 44px)
				height 8px
				background transparent
				border none
				border-radius 4px
				overflow hidden

				&::-webkit-progress-value
					background $theme-color

				&::-webkit-progress-bar
					background rgba($theme-color, 0.1)

			> .progress
				-webkit-appearance none
				-moz-appearance none
				appearance none
				display block
				position absolute
				bottom 0
				right 0
				margin 0
				width calc(100% - 44px)
				height 8px
				border none
				border-radius 4px
				background linear-gradient(
					45deg,
					darken($theme-color, 10%) 25%,
					$theme-color              25%,
					$theme-color              50%,
					darken($theme-color, 10%) 50%,
					darken($theme-color, 10%) 75%,
					$theme-color              75%,
					$theme-color
				)
				background-size 32px 32px
				animation bg 1.5s linear infinite

				&.initing
					opacity 0.3

				@keyframes bg
					from {background-position: 0 0;}
					to   {background-position: -64px 32px;}

	[name='file']
		display none

	[name='text']
		-webkit-appearance none
		-moz-appearance none
		appearance none
		display block
		box-sizing border-box
		padding 12px
		margin 0
		width 100%
		max-width 100%
		min-width 100%
		min-height calc(1em + 12px + 12px)
		font-size 1em
		color #333
		background #fff
		background-clip padding-box
		outline none
		border solid 1px rgba($theme-color, 0.1)
		border-radius 4px
		transition border-color .3s ease
		font-family 'Meiryo', 'メイリオ', 'Meiryo UI', '游ゴシック', 'YuGothic', 'ヒラギノ角ゴ ProN W3', 'Hiragino Kaku Gothic ProN', sans-serif

		&:hover
			border-color rgba($theme-color, 0.2)
			transition border-color .1s ease

		&:focus
			color $theme-color
			border-color rgba($theme-color, 0.5)
			transition border-color 0s ease

		&:disabled
			opacity 0.5

		&::-webkit-input-placeholder
			color rgba($theme-color, 0.3)

	[name='submit']
		-webkit-appearance none
		-moz-appearance none
		appearance none
		display block
		position absolute
		bottom 16px
		right 16px
		cursor pointer
		box-sizing border-box
		padding 0
		margin 0
		width 100px
		height 40px
		font-size 1em
		color $theme-color-foreground
		background linear-gradient(to bottom, lighten($theme-color, 25%) 0%, lighten($theme-color, 10%) 100%)
		outline none
		border solid 1px lighten($theme-color, 15%)
		border-radius 4px
		box-shadow none

		&:hover
			background linear-gradient(to bottom, lighten($theme-color, 8%) 0%, darken($theme-color, 8%) 100%)
			border-color $theme-color

		&:active
			background $theme-color
			border-color $theme-color

		&:focus
			&:after
				content ""
				pointer-events none
				position absolute
				top -5px
				right -5px
				bottom -5px
				left -5px
				border 2px solid rgba($theme-color, 0.3)
				border-radius 8px

	[name='upload']
	[name='drive']
		-webkit-appearance none
		-moz-appearance none
		appearance none
		display inline-block
		position relative
		cursor pointer
		box-sizing border-box
		padding 0
		margin 8px 4px 0 0
		width 40px
		height 40px
		font-size 1em
		color rgba($theme-color, 0.5)
		background transparent
		outline none
		border solid 1px transparent
		border-radius 4px
		box-shadow none

		&:hover
			background transparent
			border-color rgba($theme-color, 0.3)

		&:active
			background linear-gradient(to bottom, lighten($theme-color, 80%) 0%, lighten($theme-color, 90%) 100%)
			border-color rgba($theme-color, 0.5)

		&:focus
			&:after
				content ""
				pointer-events none
				position absolute
				top -5px
				right -5px
				bottom -5px
				left -5px
				border 2px solid rgba($theme-color, 0.3)
				border-radius 8px

script.
	@is-open = false
	@wait = false
	@uploadings = []
	@files = []

	@opts.ui.on \toggle-post-form ~>
		@toggle!

	@clear = ~>
		@text.value = ''
		@update!

	@toggle = ~>
		if @is-open
			@close!
		else
			@open!

	@open = ~>
		@is-open = true
		@opts.ui.trigger \on-blur

		@bg.style.pointer-events = \auto
		@container.style.pointer-events = \auto

		Velocity @bg, \finish true
		Velocity @bg, {
			opacity: 1
		} {
			queue: false
			duration: 100ms
			easing: \linear
		}

		Velocity @form, \finish true
		Velocity @form, {scale: 1.2} 0ms
		Velocity @form, {
			opacity: 1
			scale: 1
		} {
			queue: false
			duration: 1000ms
			easing: [ 300, 8 ]
		}

		@text.focus!

	@close = ~>
		@is-open = false
		@opts.ui.trigger \off-blur 300ms

		@bg.style.pointer-events = \none
		@container.style.pointer-events = \none

		Velocity @bg, \finish true
		Velocity @bg, {
			opacity: 0
		} {
			queue: false
			duration: 300ms
			easing: \linear
		}

		Velocity @form, \finish true
		Velocity @form, {
			opacity: 0
			scale: 0.8
		} {
			queue: false
			duration: 300ms
			easing: [ 0.5, -0.5, 1, 0.5 ]
		}

	@repel-close = (e) ~>
		e.stop-propagation!
		return true

	@select-file = ~>
		@file.click!

	@change-file = ~>
		files = @file.files
		for i from 0 to files.length - 1
			file = files.item i
			@upload file

	@upload = (file) ~>
		ctx =
			name: file.name
			progress: undefined

		@uploadings.push ctx
		@update!

		reader = new FileReader!
		reader.onload = (e) ~>
			ctx.img = e.target.result
			@update!
		reader.read-as-data-URL file

		data = new FormData!
		data.append \_i USER._web
		data.append \file file

		xhr = new XMLHttpRequest!
		xhr.open \POST CONFIG.api.url + '/drive/files/create' true
		xhr.onload = (e) ~>
			drive-file = JSON.parse e.target.response
			console.log drive-file
			alert \yeah

		xhr.upload.onprogress = (e) ~>
			if e.length-computable
				if ctx.progress == undefined
					ctx.progress = {}
				ctx.progress.max = e.total
				ctx.progress.value = e.loaded
				@update!

		xhr.send data

	@post = (e) ~>
		@wait = true
		api 'posts/create' do
			'text': @text.value
		.then (data) ~>
			@close!
			@clear!
			@opts.ui.trigger \notification '投稿しました。'
		.catch (err) ~>
			console.error err
			@opts.ui.trigger \notification 'Error!'
		.then ~>
			@wait = false
			@update!
