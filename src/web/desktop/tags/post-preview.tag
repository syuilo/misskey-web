mk-post-preview(title={ title })
	article
		a.avatar-anchor(href= config.url + '/' + { post.user.username })
			img.avatar(src={ post.user.avatar_url + '?thumbnail&size=64' }, alt='avatar', data-user-card={ post.user.username })
		div.main
			header
				div.left
					a.name(href= config.url + '/' + { post.user.username })
						| { post.user.name }
					span.username
						| @{ post.user.username }
				div.right
					a.time
						| { post.created_at }
			div.body
				div.text
					| { post.text }

script.
	@title = 'a'
	@post = @opts.post

style.
	display block
	position relative
	margin 0
	padding 0
	font-family 'Meiryo', 'メイリオ', 'sans-serif'
	font-size 0.9em
	background #fff
	background-clip padding-box

	> article
		position relative
		padding 16px

		&:after
			content ""
			display block
			clear both

		&:hover
			> .main > footer > button
				color #888

		> .avatar-anchor
			display block
			float left
			margin 0 16px 0 0

			> .avatar
				display block
				width 52px
				height 52px
				margin 0
				border-radius 8px
				vertical-align bottom

		> .main
			float left
			width calc(100% - 68px)

			> header
				margin-bottom 4px
				white-space nowrap

				> .left
					> .name
						display inline
						margin 0
						padding 0
						color #736060
						font-size 1em
						font-weight 700
						text-align left
						text-decoration none

						&:hover
							text-decoration underline

					> .username
						text-align left
						margin 0 0 0 8px
						color #e2d1c1

				> .right
					position absolute
					top 16px
					right 16px

					> .time
						color #b7a793

			> .body

				> .text
					cursor default
					display block
					margin 0
					padding 0
					word-wrap break-word
					font-size 1.1em
					color #717171
