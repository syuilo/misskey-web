mk-user-recommendation-home-widget
	div.user(each={ user in users })
		p.name { user.name }
		p.username { user.username }
		mk-follow-button(user={ user })

style.
	display block
	background #fff

	> .user
		border-bottom solid 1px #eee

script.
	@users = null

	@on \mount ~>
		api 'users/recommendation'
			.then (users) ~>
				@users = users
				@update!
			.catch (err, text-status) ->
				console.error err
