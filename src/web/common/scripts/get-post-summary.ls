module.exports = (post) ~>
	summary = if post.text? then post.text else ''
	if post.images?
		summary += " (#{post.images.length}枚の画像)"
	if post.reply_to?
		if typeof post.reply_to == \string
			summary += " RE: ..."
		else
			reply-summary = get-post-summary post.reply_to
			summary += " RE: #{reply-summary}"
	if post.repost?
		if typeof post.reply_to == \string
			summary = summary + " RP: ..."
		else
			repost-summary = get-post-summary post.repost
			summary = summary + " RP: #{repost-summary}"
	return summary.trim!
