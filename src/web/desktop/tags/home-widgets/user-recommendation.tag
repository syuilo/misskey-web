mk-user-recommendation-home-widget
	div.user(each={ user in users })
		p { user.name }
		mk-follow-button(user={ user })

style.
	display block
	background #fff

script.
	@users = null

	@on \mount ~>
		api 'users/recommendation'
			.then (users) ~>
				@users = users
				@update!
			.catch (err, text-status) ->
				console.error err
