mk-user-preview
	div.banner@banner(style={ user.banner_url ? 'background-image: url(' + user.banner_url + '?thumbnail&size=1024)' : '' }, onclick={ on-update-banner })
	a.avatar(href={ CONFIG.url + '/' + user.username }, target='_blank'): img(src={ user.avatar_url + '?thumbnail&size=64' }, alt='avatar')
	div.title
		p.name { user.name }
		p.username @{ user.username }
	div.bio { user.bio }

style.
	display block
	position absolute
	z-index 2048
	width 250px
	background #fff
	background-clip content-box
	border solid 1px rgba(0, 0, 0, 0.1)
	border-radius 4px
	overflow hidden

	> .banner
		height 84px
		background-color #f5f5f5
		background-size cover
		background-position center

	> .avatar
		display block
		position absolute
		top 54px
		left 14px

		> img
			display block
			width 58px
			height 58px
			margin 0
			border solid 3px #fff
			border-radius 8px

	> .title
		display block
		padding 8px 0 8px 86px
		color #656565

		> .name
			display block
			margin 0
			font-weight bold
			line-height 16px

		> .username
			display block
			margin 0
			line-height 16px
			opacity 0.8

	> .bio
		padding 0 16px
		font-size 0.7em
		color #555

script.
	@q = @opts.user
	@user = null

	@on \mount ~>
		api \users/show do
			id: if @q.0 == \@ then undefined else @q
			username: if @q.0 == \@ then @q.substr 1 else undefined
		.then (user) ~>
			@user = user
			@update!
