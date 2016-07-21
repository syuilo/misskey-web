mk-post-form
	div@bg
	div@container(onclick={ close }): form@form(onclick={ repel-close }, class={ wait: wait })
		h1 新規投稿
		div.body
			textarea@text(placeholder='いまどうしてる？')
			button@submit(onclick={ post }) 投稿

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

		h1
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

		.body
			padding 16px
			background lighten($theme-color, 95%)

			&:after
				content ""
				display block
				clear both

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
		&::-moz-input-placeholder
		&::input-placeholder
			color rgba($theme-color, 0.3)

	[name='submit']
		-webkit-appearance none
		-moz-appearance none
		appearance none
		display block
		position relative
		float right
		cursor pointer
		box-sizing border-box
		padding 0
		margin 8px 0 0 0
		width 100px
		font-size 1em
		line-height 40px
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
		.then ~>
			@wait = false
			@update!
