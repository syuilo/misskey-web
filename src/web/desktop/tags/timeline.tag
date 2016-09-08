mk-timeline
	virtual(each={ _post in posts })
		mk-post(post={ _post })
	footer
		i.fa.fa-moon-o

style.
	display block

	> mk-post
		border-bottom solid 1px #eaeaea

		&:first-child
			border-top-left-radius 4px
			border-top-right-radius 4px
		
		&:last-of-type
			border-bottom none

	> footer
		padding 16px
		text-align center
		color #ccc
		border-top solid 1px #eaeaea
		border-bottom-left-radius 4px
		border-bottom-right-radius 4px

script.
	@posts = []
	@controller = @opts.controller

	@controller.on \set-posts (posts) ~>
		@posts = posts
		@update!

	@controller.on \add-post (post) ~>
		@posts.unshift post
		@update!
	
	@controller.on \clear ~>
		@posts = []
		@update!

	@controller.on \focus ~>
		@tags['mk-post'].0.root.focus!
