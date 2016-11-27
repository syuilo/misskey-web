mk-user-followers
	nav
		span(data-is-active={ mode == 'all' }, onclick={ set-mode.bind(this, 'all') })
			| すべて
			span { user.followers_count }
		span(if={ SIGNIN && I.id != user.id }, data-is-active={ mode == 'iknow' }, onclick={ set-mode.bind(this, 'iknow') })
			| 知り合い
			span { user.followers_you_know_count }

	div.users(if={ !fetching && users.length != 0 })
		mk-user-preview(each={ users }, user={ this })

	button.more(if={ !fetching && next != null }, onclick={ more }, disabled={ more-fetching })
		span(if={ !more-fetching }) もっと
		span(if={ more-fetching })
			| 読み込み中
			mk-ellipsis

	p.no(if={ !fetching && users.length == 0 })
		| フォロワーはいないようです。
	p.fetching(if={ fetching })
		i.fa.fa-spinner.fa-pulse.fa-fw
		| 読み込んでいます
		mk-ellipsis

style.
	display block
	background #fff

	> nav
		display flex
		justify-content center
		margin 0 auto
		max-width 600px
		border-bottom solid 1px #ddd

		> span
			display block
			flex 1 1
			text-align center
			line-height 52px
			font-size 14px
			color #657786
			border-bottom solid 2px transparent

			&[data-is-active]
				font-weight bold
				color $theme-color
				border-color $theme-color

			> span
				display inline-block
				margin-left 4px
				padding 2px 5px
				font-size 12px
				line-height 1
				color #888
				background #eee
				border-radius 20px

	> .users
		> *
			max-width 600px
			margin 0 auto
			border-bottom solid 1px rgba(0, 0, 0, 0.05)

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
	@mixin \i
	@mixin \api

	@limit = 30users
	@mode = \all

	@user = @opts.user
	@event = @opts.event

	@fetching = true
	@more-fetching = false

	@on \mount ~>
		@fetch ~>
			if @event? then @event.trigger \loaded

	@fetch = (cb) ~>
		@fetching = true
		@update!
		@api \users/followers do
			user: @user.id
			iknow: @mode == \iknow
			limit: @limit
		.then (obj) ~>
			@users = obj.users
			@next = obj.next
			@fetching = false
			@update!

	@more = ~>
		@more-fetching = true
		@update!
		@api \users/followers do
			user: @user.id
			iknow: @mode == \iknow
			limit: @limit
			cursor: @next
		.then (obj) ~>
			@users = @users.concat obj.users
			@next = obj.next
			@more-fetching = false
			@update!

	@set-mode = (mode) ~>
		@update do
			mode: mode

		@fetch!
