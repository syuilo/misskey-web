mk-post-form
	div@bg
	div@container(onclick={ close }): form@form(onclick={ cancel-close })
		h1 新規投稿
		div.body
			textarea@text(placeholder='いまどうしてる？')
			button(onclick={ post }) 投稿

style.
	[name='bg']
	[name='container']
		display none
		position fixed
		top 0
		width 100%
		height 100%

	[name='bg']
		z-index 127
		left 0
		background rgba(0, 0, 0, 0.7)
		opacity 0

	[name='container']
		z-index 1024

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

		h1
			display block
			margin 0
			text-align center
			font-size 1.2em
			line-height 40px
			font-weight normal
			color #d0b4ac
			background #fff
			background-clip padding-box
			border-bottom solid 1px rgba($theme-color, 0.1)

		.body
			padding 16px
			background lighten($theme-color, 95%)

		textarea
			-webkit-appearance none
			-moz-appearance none
			appearance none
			user-select text
			-moz-user-select text
			-webkit-user-select text
			-ms-user-select text
			display inline-block
			cursor auto
			box-sizing border-box
			padding 12px
			margin 0
			width 100%
			font-size 1em
			color #333
			background #fff
			background-clip padding-box
			outline none
			border solid 1px rgba($theme-color, 0.1)
			border-radius 4px
			transition all .3s ease
			font-family 'Meiryo', 'メイリオ', 'Meiryo UI', '游ゴシック', 'YuGothic', 'ヒラギノ角ゴ ProN W3', 'Hiragino Kaku Gothic ProN', sans-serif

			&:hover
				border-color rgba($theme-color, 0.2)
				transition all .1s ease

			&:focus
				color $theme-color
				border-color $theme-color
				box-shadow 0 0 0 1024px #fff inset, 0 0 0 4px rgba($theme-color, 10%)
				transition all 0s ease

			&:disabled
				opacity 0.5

script.
	@is-open = false

	@opts.ui.on \toggle-post-form ~>
		@toggle!

	@toggle = ~>
		if @is-open
			@close!
		else
			@open!

	@open = ~>
		@is-open = true
		@opts.ui.trigger \on-blur

		$bg = $ @bg
		$container = $ @container
		$form = $ @form

		$bg
			.css do
				'display': \block
				'pointer-events': ''
			.animate {
				opacity: 1
			} 100ms \linear

		$container.css do
			'display': \block
			'pointer-events': ''

		$form
			.stop!
			.css \transform 'scale(1.2)'
			.transition {
				opacity: \1
				scale: \1
			} 1000ms 'cubic-bezier(0, 1, 0, 1)'

	@close = ~>
		@is-open = false
		@opts.ui.trigger \off-blur

		$bg = $ @bg
		$container = $ @container
		$form = $ @form

		$bg
			.css \pointer-events \none
			.animate {
				opacity: 0
				} 100ms \linear -> $bg.css \display \none

		$container.css \pointer-events \none

		$form
			.stop!
			.transition {
				opacity: \0
				scale: \0.8
			} 1000ms 'cubic-bezier(0, 1, 0, 1)' ->
				if ($form.css \opacity) === '0'
					$container.css \display \none

	@cancel-close = (e) ~>
		e.stop-propagation!

	@post = (e) ~>
		api 'posts/create' {
			'text': @text.value
		}
		.done (data) ->
			console.log data
		.fail (err, text-status) ->
			console.error err
