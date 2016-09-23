mk-user-header
	div.banner@banner(style={ user.banner_url ? 'background-image: url(' + user.banner_url + '?thumbnail&size=1024)' : '' })
	img.avatar(src={ user.avatar_url + '?thumbnail&size=150' }, alt='avatar')
	div.title
		p.name(href= config.url + '/' + { user.username }) { user.name }
		p.username @{ user.username }
	footer
		p
			b { user.posts_count }
			| 投稿

style.
	$footer-height = 58px

	display block
	position relative
	background #fff

	> .banner
		height 280px
		background-color #f5f5f5
		background-size cover
		background-position center

	> .avatar
		display block
		position absolute
		bottom 16px
		left 16px
		z-index 2
		width 150px
		height 150px
		margin 0
		border solid 3px #fff
		border-radius 8px
		box-shadow 1px 1px 3px rgba(0, 0, 0, 0.2)

	> .title
		position absolute
		bottom $footer-height
		left 0
		width 100%
		background linear-gradient(transparent, rgba(0, 0, 0, 0.7))

		> .name
			display block
			margin 0 0 0 190px
			line-height 40px
			font-weight bold
			font-size 2em
			color #fff
			font-family '游ゴシック', 'YuGothic', 'ヒラギノ角ゴ ProN W3', 'Hiragino Kaku Gothic ProN', 'Meiryo', 'メイリオ', sans-serif
			text-shadow 0 0 8px #000

		> .username
			display block
			margin 0 0 8px 195px
			line-height 20px
			color rgba(#fff, 0.8)

	> footer
		position relative
		z-index 1
		height $footer-height
		padding-left 195px
		background #fff

		> p
			display inline-block
			margin 0
			line-height $footer-height
			color #555

script.
	@user = @opts.user

	@on \mount ~>
		window.add-event-listener \load @scroll
		window.add-event-listener \scroll @scroll
		window.add-event-listener \resize @scroll

	@on \unmount ~>
		window.remove-event-listener \load @scroll
		window.remove-event-listener \scroll @scroll
		window.remove-event-listener \resize @scroll

	@scroll = ~>
		top = window.scroll-y
		height = 280px

		pos = 50 - ((top / height) * 50)
		@banner.style.background-position = 'center ' + pos + '%'

		blur = top / 32
		if blur <= 10
			@banner.style.filter = 'blur(' + blur + 'px)'
