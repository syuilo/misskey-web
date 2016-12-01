mk-user-following
	mk-users-list(fetch={ fetch }, count={ user.following_count }, you-know-count={ user.following_you_know_count }, no-users={ 'フォロー中のユーザーはいないようです。' }, event={ event })

style.
	display block

script.
	@mixin \api

	@user = @opts.user
	@event = @opts.event

	console.log @user.following_you_know_count

	@fetch = (iknow, limit, cursor, cb) ~>
		@api \users/following do
			user_id: @user.id
			iknow: iknow
			limit: limit
			cursor: if cursor? then cursor else undefined
		.then cb
