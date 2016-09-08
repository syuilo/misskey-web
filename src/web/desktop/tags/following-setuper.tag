mk-following-setuper
	p.title 気になるユーザーをフォロー:
	div.user(if={ users.length != 0 }, each={ user in users })
		a.avatar-anchor(href= config.url + '/' + { user.username })
			img.avatar(src={ user.avatar_url + '?thumbnail&size=42' }, alt='', data-user-card={ user.username })
		div.body
			p.name { user.name }
			p.username @{ user.username }
		mk-follow-button(user={ user })
	p.empty(if={ users.length == 0 })
		| おすすめのユーザーは見つかりませんでした。
	p.init(if={ init })
		i.fa.fa-spinner.fa-pulse.fa-fw
		| 読み込んでいます...
	button.close(onclick={ close }): i.fa.fa-times

style.
	display block
	position relative
	padding 24px
	background #fff

	&:after
		content ""
		display block
		clear both

	> .title
		margin 0 0 12px 0
		font-size 1em
		font-weight bold
		color #888

	> .user
		position relative
		padding 16px
		width 200px
		float left

		&:after
			content ""
			display block
			clear both

		> .avatar-anchor
			display block
			float left
			margin 0 16px 0 0

			> .avatar
				display block
				width 42px
				height 42px
				margin 0
				border-radius 8px
				vertical-align bottom

		> .body
			float left
			width calc(100% - 64px)

			> .name
				margin 0
				color #555
			
			> .username
				margin 0
				color #ccc
		
		> mk-follow-button
			position absolute
			top 16px
			right 16px

	> .empty
		margin 0
		padding 16px
		text-align center
		color #aaa

	> .init
		margin 0
		padding 16px
		text-align center
		color #aaa

		> i
			margin-right 4px

	> .close
		appearance none
		cursor pointer
		display block
		position absolute
		top 6px
		right 6px
		z-index 1
		margin 0
		padding 0
		font-size 1.2em
		color #999
		border none
		outline none
		box-shadow none
		background transparent

		&:hover
			color #555

		&:active
			color #222

		> i
			padding 14px

script.
	@users = null
	@init = true

	@on \mount ~>
		api \users/recommendation do
			limit: 6users
		.then (users) ~>
			@init = false
			@users = users
			@update!
		.catch (err, text-status) ->
			console.error err

	@close = ~>
		@unmount!