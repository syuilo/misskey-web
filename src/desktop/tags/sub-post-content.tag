mk-sub-post-content
	div.body
		a.reply(if={ post.reply_to }): i.fa.fa-reply
		span@text
		a.quote(if={ post.repost }, href={ '/post:' + post.repost }) RP: ...
	details(if={ post.images })
		summary ({ post.images.length }枚の画像)
		mk-images-viewer(images={ post.images })

style.
	display block
	word-wrap break-word

	> .body
		> .reply
			margin-right 6px
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
		if @post.text?
			tokens = @analyze @post.text
			@refs.text.innerHTML = @compile tokens, false

			@refs.text.children.for-each (e) ~>
				if e.tag-name == \MK-URL
					riot.mount e
