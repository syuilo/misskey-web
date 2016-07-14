mk-post-form
	div.bg
	div.container
		form
			textarea@text
			button(onclick={post}) 投稿

script.
	@is-open = false

	@opts.core.on \toggle-post-form ~>
		@toggle!

	@toggle = ~>
		if @is-open
			@close!
		else
			@open!

	@open = ~>
		@is-open = true
		@opts.core.trigger \on-modal

	@close = ~>
		@is-open = false
		@opts.core.trigger \off-modal

	@post = (e) ~>
		$.ajax CONFIG.urls.api + '/posts/create' { data: {
			'text': @text.value
		}}
		.done (data) ->
			console.log data
		.fail (err, text-status) ->
			console.error err
