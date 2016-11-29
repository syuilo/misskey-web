mk-user-followers-page
	mk-ui: mk-user-followers(if={ !parent.fetching }, user={ parent.user }, event={ parent.event })

style.
	display block

script.
	@mixin \ui
	@mixin \ui-progress
	@mixin \api

	@fetching = true
	@user = null
	@event = riot.observable!

	@on \mount ~>
		@Progress.start!

		@api \users/show do
			username: @opts.user
		.then (user) ~>
			@user = user
			@fetching = false

			document.title = user.name + 'のフォロワー | Misskey'
			# TODO: ユーザー名をエスケープ
			@ui.trigger \title '<img src="' + user.avatar_url + '?thumbnail&size=64">' + user.name + 'のフォロー'

			@update!

	@event.on \loaded ~>
		@Progress.done!
