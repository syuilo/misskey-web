mk-user-graphs
	section
		h1 投稿
		canvas@chart(width='750', height='250')

	//
		section
			h1 いいね
			canvas@chart(width='750', height='250')

		section
			h1 フォロー/フォロワー
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

			api \aggregation/users/posts do
				user: @user.id
				limit: 30days
			.then (data) ~>
				data = data.reverse!
				new Chart @chart, do
					type: \line
					data:
						labels: data.map (x, i) ~> if i % 3 == 1 then x.date.day + '日' else ''
						datasets:[
							{
								label: \投稿
								data: data.map (x) ~> x.posts
								line-tension: 0
								point-radius: 0
								background-color: \#555
								border-color: \transparent
							},
							{
								label: \Repost
								data: data.map (x) ~> x.reposts
								line-tension: 0
								point-radius: 0
								background-color: \#a2d61e
								border-color: \transparent
							},
							{
								label: \返信
								data: data.map (x) ~> x.replies
								line-tension: 0
								point-radius: 0
								background-color: \#F7796C
								border-color: \transparent
							}
						]
					options:
						responsive: false
						scales:
							x-axes: [
								{
									stacked: true
								}
							]
							y-axes: [
								{
									stacked: true
								}
							]
