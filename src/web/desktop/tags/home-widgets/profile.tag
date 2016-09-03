mk-profile-home-widget
	div.banner(style={ 'background-image: url(' + I.banner_url + '?thumbnail&size=256)' })
	a.avatar-anchor(href= config.url + '/' + { I.username })
		img.avatar(src={ I.avatar_url + '?thumbnail&size=64' }, alt='avatar', data-user-card={ I.username })
	p.name { I.name }
	p.username @{ I.username }

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