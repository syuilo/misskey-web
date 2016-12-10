mk-user-followers
	mk-users-list(fetch={ fetch }, count={ user.followers_count }, you-know-count={ user.followers_you_know_count }, no-users={ 'フォロワーはいないようです。' }, event={ event })

style.
	display block
	height 100%

script.
	@mixin \api

	@user = @opts.user
	@event = @opts.event

	@fetch = (iknow, limit, cursor, cb) ~>
		@api \users/followers do
			user_id: @user.id
			iknow: iknow
			limit: limit
			cursor: if cursor? then cursor else undefined
		.then cb
