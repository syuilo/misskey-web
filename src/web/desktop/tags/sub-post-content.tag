mk-sub-post-content
	div.body
		a.reply(if={ post.reply_to }): i.fa.fa-reply
		span@text
		a.quote(if={ post.repost != null }) RP: ...
	details(if={ post.images })
		summary ({ post.images.length }枚の画像)
		virtual(each={ file in post.images })
			img(src={ file.url + '?thumbnail&size=512' }, alt={ file.name }, title={ file.name })

style.
	display block
	word-wrap break-word

	> .body
		> .reply
			margin-right 4px
			color #717171

		> .quote
			margin-left 4px
			font-style oblique
			color #a0bf46

script.
	@mixin \text
	@mixin \user-preview

	@post = @opts.post

	@on \mount ~>
		# ↓の @post? はRiotのバグのため付与しています
		# このバグ(https://github.com/riot/riot/issues/1020)が修正され次第消してください
		# Riot3.0.0では修正されるみたい
		if @post? and @post.text?
			tokens = @analyze @post.text
			@text.innerHTML = @compile tokens, false

			@text.child-nodes.for-each (e) ~>
				if e.tag-name == \MK-URL
					riot.mount e
