mk-post(tabindex='-1', title={title})

	// i.fa.fa-ellipsis-v.talk-ellipsis(if={reply_to.reply_to?})

	// mk-post(if={reply_to?})

	article(lang={user.lang})
		div
			| {text}

	// i.fa.fa-ellipsis-v.replies-ellipsis(if={replies_count > 0})

script.
	@title = 'a'

	@favorite = (e) ->
		alert \favorited
