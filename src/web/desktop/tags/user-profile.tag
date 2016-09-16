mk-user-profile
	div.banner(style={ user.banner_url ? 'background-image: url(' + user.banner_url + '?thumbnail&size=256)' : '' })
	a.avatar-anchor(href= config.url + '/' + { user.username })
		img.avatar(src={ user.avatar_url + '?thumbnail&size=64' }, alt='avatar', data-user-card={ user.username })
	a.name(href= config.url + '/' + { user.username }) { user.name }
	p.username @{ user.username }
	div.friend-form(if={ SIGNIN && I.id != user.id })
		mk-big-follow-button(user={ user })
		p.followed(if={ user.is_followed }) フォローされています
	div.bio(if={ user.bio != '' }) { user.bio }
	div.friends
		p.following
			i.fa.fa-angle-right
			a { user.following_count }
			| 人を
			b フォロー
		p.followers
			i.fa.fa-angle-right
			a { user.followers_count }
			| 人の
			b フォロワー

style.
	position relative
	background #fff

	> .banner
		height 100px
		background-color #f5f5f5

	> .avatar-anchor
		display block
		position absolute
		top 76px
		left 16px

		> .avatar
			display block
			width 58px
			height 58px
			margin 0
			border solid 3px #fff
			border-radius 8px
			vertical-align bottom

	> .name
		display block
		margin 8px 0 0 92px
		font-weight bold
		color #555

	> .username
		display block
		margin 4px 0 8px 92px
		color #999
	
	> .friend-form
		padding 16px
		border-top solid 1px #eee

		> mk-big-follow-button
			width 100%

		> .followed
			margin 12px 0 0 0
			padding 0
			text-align center
			line-height 24px
			font-size 0.8em
			color #71afc7
			background #eefaff
			border-radius 4px

	> .bio
		padding 16px
		color #555
		border-top solid 1px #eee
	
	> .friends
		padding 16px
		color #555
		border-top solid 1px #eee

		> p
			margin 8px 0

			> i
				margin-left 8px
				margin-right 8px

script.
	@user = @opts.user
