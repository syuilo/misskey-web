mk-timeline
	virtual(each={ _post in posts })
		mk-post(post={ _post })

style.
	display block

	> mk-post
		border-bottom solid 1px #eaeaea

		&:first-child
			border-top-left-radius 4px
			border-top-right-radius 4px

		&:last-child
			border-bottom-left-radius 4px
			border-bottom-right-radius 4px
			border-bottom none

		& + mk-post
			border-top none

script.
	@posts = []
	@controller = @opts.controller

	@controller.on \set-posts (posts) ~>
		@posts = posts
		@update!

	@controller.on \add-post (post) ~>
		@posts.unshift post
		@update!
