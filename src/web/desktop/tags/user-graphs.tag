mk-user-graphs
	section
		h1 直近30日間の投稿アクティビティ
		canvas@chart(width='750', height='250')

style.
	display block

	> section
		margin 16px 0
		background #fff
		border solid 1px rgba(0, 0, 0, 0.1)
		border-radius 4px

		> h1
			margin 0 0 8px 0
			padding 0 16px
			line-height 40px
			font-size 1em
			color #666
			border-bottom solid 1px #eee

		> canvas
			margin 0 auto 16px auto

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
				new Chart @chart, do
					type: \line
					data:
						labels: data.map (x) ~> new Date x.date
						datasets:[
							{
								label: \投稿
								data: data.map (x) ~> x.posts
								background-color: \#555
								point-radius: 0
							},
							{
								label: \Repost
								data: data.map (x) ~> x.reposts
								background-color: \#a2d61e
								point-radius: 0
							},
							{
								label: \返信
								data: data.map (x) ~> x.replies
								background-color: \#F7796C
								point-radius: 0
							}
						]
					options:
						responsive: false
						scales:
							x-axes: [
								{
									stacked: true
									type: \time
									time:
										unit: \day
										#min-unit: \day
										#round: \day
										display-formats:
											day: 'M月 D日'
								}
							]
							y-axes: [
								{
									stacked: true
								}
							]
