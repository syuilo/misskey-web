mk-header-clock
	div.header
		time@time(datetime= Date.now())
	div.content
		mk-analog-clock

script.
	self = @

	draw!
	set-interval draw, 1000ms

	function draw
		s = (new Date!).get-seconds!
		m = (new Date!).get-minutes!
		h = (new Date!).get-hours!
		yyyymmdd = moment!.format 'YYYY/MM/DD'
		yyyymmdd = "<span class='yyyymmdd'>#yyyymmdd</span>"
		hhmm = moment!.format 'HH:mm'
		if s % 2 == 0
			hhmm .= replace \: '<span style=\'visibility:visible\'>:</span>'
		else
			hhmm .= replace \: '<span style=\'visibility:hidden\'>:</span>'
		clock = self.time
		clock.innerHTML = "#yyyymmdd<br>#hhmm"

style.
	$ui-controll-background-color = #fffbfb
	$ui-controll-foreground-color = #ABA49E

	display inline-block
	position relative
	overflow visible

	> .header
		padding 0 12px
		text-align center
		font-size 0.5em

		&, *
			cursor: default

		&:hover
			background #949289

			& + .content
				visibility visible

			> time
				color #fff !important

				*
					color #fff !important

		&:after
			content ""
			display block
			clear both

		> time
			display table-cell
			vertical-align middle
			height 48px
			color $ui-controll-foreground-color

			> .yyyymmdd
				opacity 0.7

	> .content
		visibility hidden
		display block
		position absolute
		top auto
		right 0
		z-index 3
		margin 0
		padding 0
		width 256px
		background #949289
