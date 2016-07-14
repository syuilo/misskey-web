mk-post(tabindex='-1', lang={user.lang}, title={title})

	i.fa.fa-ellipsis-v.talk-ellipsis(if={reply_to.reply_to?})

	mk-post(if={reply_to?})

	i.fa.fa-ellipsis-v.replies-ellipsis(if={replies_count > 0})

script.
	@user = opts.post.user
	@text = opts.post.text
	@reply_to = opts.post.reply_to

	@favorite = (e) ->
		alert \favorited
