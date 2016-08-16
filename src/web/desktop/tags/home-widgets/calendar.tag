mk-calendar-home-widget
	p.month-and-year
		span.year { year }年
		span.month { month }月
	p.day { day }日
	p.week-day { week-day }曜日

style.
	display block
	padding 16px 0
	color #777
	background #fff
	text-align center

	p
		margin 0

		> span
			margin 0 4px

	.day
		margin 10px 0
		font-size 2em

script.
	@draw = ~>
		now = new Date!

		@year = now.get-full-year!
		@month = now.get-month! + 1
		@day = now.get-date!
		@week-day = [\日 \月 \火 \水 \木 \金 \土][now.get-day!]

		@update!

	@on \mount ~>
		@draw!
		set-interval @draw, 1000ms
