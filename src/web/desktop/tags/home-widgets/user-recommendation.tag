mk-user-recommendation-home-widget
	p.title おすすめユーザー
	div.user(if={ users.length != 0 }, each={ user in users })
		a.avatar-anchor(href= config.url + '/' + { user.username })
			img.avatar(src={ user.avatar_url + '?thumbnail&size=64' }, alt='', data-user-card={ user.username })
		div.body
			p.name { user.name }
			p.username @{ user.username }
		mk-follow-button(user={ user })
	p.empty(if={ users.length == 0 })
		| いません！

style.
	display block
	background #fff

	> .title
		margin 0
		padding 16px
		font-weight bold
		color #888

	> .user
		padding 16px
		border-top solid 1px #eee

		> .avatar-anchor
			display block
			float left
			margin 0 16px 0 0

			> .avatar
				display block
				width 48px
				height 48px
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
	
	> .empty
		margin 0
		padding 16px
		text-align center
		color #aaa
		border-top solid 1px #eee

script.
	@users = null

	@on \mount ~>
		api 'users/recommendation'
		.then (users) ~>
			@users = users
			@update!
		.catch (err, text-status) ->
			console.error err
