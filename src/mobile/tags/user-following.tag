mk-user-following
	div.users(if={ !fetching && users.length != 0 })
		mk-user-preview(each={ users }, user={ this })

	p.no(if={ !fetching && users.length == 0 })
		| フォロー中のユーザーはいないようです。
	p.fetching(if={ fetching })
		i.fa.fa-spinner.fa-pulse.fa-fw
		| 読み込んでいます
		mk-ellipsis

style.
	display block
	background #fff

	> .users
		> *
			border-bottom solid 1px rgba(0, 0, 0, 0.05)

			&:last-child
				border-bottom none

	> .no
		margin 0
		padding 16px
		text-align center
		color #aaa

	> .fetching
		margin 0
		padding 16px
		text-align center
		color #aaa

		> i
			margin-right 4px

script.
	@mixin \api

	@user = @opts.user
	@event = @opts.event

	@fetching = true

	@on \mount ~>
		@api \users/following do
			user: @user
		.then (users) ~>
			@users = users
			@fetching = false
			if @event? then @event.trigger \loaded
			@update!
		.catch (err, text-status) ->
			console.error err
