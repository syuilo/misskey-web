mk-timeline
	virtual(each={ _post in opts.posts })
		mk-post(post={ _post })

style.
	display block

	> mk-post
		border solid 1px #eaeaea

		&:first-child
			border-top-left-radius 4px
			border-top-right-radius 4px

		&:last-child
			border-bottom-left-radius 4px
			border-bottom-right-radius 4px

		& + mk-post
			border-top none
