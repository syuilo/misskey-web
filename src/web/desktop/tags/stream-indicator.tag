mk-stream-indicator
	p(if={ state == 'initializing' })
		i.fa.fa-spinner.fa-spin
		span
			| 接続中
			mk-ellipsis
	p(if={ state == 'reconnecting' })
		i.fa.fa-spinner.fa-spin
		span
			| 切断されました 接続中
			mk-ellipsis
	p(if={ state == 'connected' })
		i.fa.fa-check
		span 接続完了

style.
	display block
	pointer-events none
	position fixed
	z-index 16384
	bottom 8px
	right 8px
	margin 0
	padding 6px 12px
	font-size 0.9em
	color #fff
	background rgba(0, 0, 0, 0.8)

	> p
		display block
		margin 0

		> i
			margin-right 0.25em

script.
	@mixin \stream

	@state = 'initializing'

	@stream-state.on \connected ~>
		@state = 'connected'
		@update!
		set-timeout ~>
			Velocity @root, {
				opacity: 0
			} 200ms \linear
		, 1000ms

	@stream-state.on \closed ~>
		@state = 'reconnecting'
		@update!
		Velocity @root, {
			opacity: 1
		} 0ms
