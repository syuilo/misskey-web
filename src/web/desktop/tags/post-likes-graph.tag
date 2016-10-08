mk-post-likes-graph
	canvas@canv(width={ opts.width }, height={ opts.height })

style.
	display block

script.
	@post = null
	@post-promise = if is-promise @opts.post then @opts.post else Promise.resolve @opts.post

	@on \mount ~>
		post <~ @post-promise.then
		@post = post
		@update!

		api \aggregation/posts/likes do
			post: @post.id
			limit: 30days
		.then (likes) ~>
			likes = likes.reverse!

			new Chart @canv, do
				type: \line
				data:
					labels: likes.map (x, i) ~> if i % 3 == 2 then x.date.day + '日' else ''
					datasets: [
						{
							label: \いいね
							data: likes.map (x) ~> x.count
							line-tension: 0
							border-width: 2
							fill: true
							background-color: 'rgba(247, 121, 108, 0.2)'
							point-background-color: \#fff
							point-radius: 4
							point-border-width: 2
							border-color: \#F7796C
						}
					]
				options:
					responsive: false
