mk-post-form
	textarea(name='text')
	button(onclick='{post}') ようこう
	!
	textarea(na
	textarea(name=)

	script.
		@post = (e) ~>
			$.ajax "#{CONFIG.urls.api}/posts/create", { data: {
				'text': @text.value
			}}
			.done (data) ->
				console.log data
			.fail (err, text-status) ->
				console.error err
