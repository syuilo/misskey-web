mk-user-graphs
	section
		h1 直近30日間の投稿アクティビティ
		div.ct-chart.ct-double-octave@chart

style.
	display block

	> section
		margin 16px 0
		background #fff
		border solid 1px rgba(0, 0, 0, 0.1)
		border-radius 4px

		> h1
			margin 0 0 16px 0
			padding 0 16px
			line-height 40px
			font-size 1em
			color #666
			border-bottom solid 1px #eee

		> div
			.ct-series-a > .ct-line
				stroke $theme-color

			.ct-series-a > .ct-area
				fill $theme-color

			.ct-series-b > .ct-line
				stroke #a99c9a

			.ct-series-c > .ct-line
				stroke #a2d61e

			.ct-series-d > .ct-line
				stroke #1ed6ba

script.
	@user-promise = @opts.user
	@event = @opts.event

	@on \mount ~>
		@event.trigger \loaded

		@user-promise.then (user) ~>
			@user = user

			api \users/posts/aggregate do
				user: @user.id
				limit: 30days
			.then (data) ~>
				console.log data

				data = data.reverse!

				new Chartist.Line @chart, do
					labels: data.map (x) ~> x.day
					series: [
						{
							name: \total
							data: data.map (x) ~> x.posts + x.reposts + x.replies
						},
						{
							name: \post
							data: data.map (x) ~> x.posts
						},
						{
							name: \repost
							data: data.map (x) ~> x.reposts
						},
						{
							name: \reply
							data: data.map (x) ~> x.replies
						}
					]
				, do
					series:
						total:
							show-area: true
							show-point: false
						post:
							show-point: false
						repost:
							show-point: false
						reply:
							show-point: false
