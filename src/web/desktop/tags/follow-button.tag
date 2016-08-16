mk-follow-button
	button(onclick={ follow })
		i.fa.fa-user-plus

script.
	@follow = ~>
		api 'following/create' do
			user_id: @user.id
		.then (users) ~>
			@users = users
			@update!
		.catch (err, text-status) ->
			console.error err
