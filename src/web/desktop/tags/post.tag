mk-post(tabindex='-1', title={title})

	// i.fa.fa-ellipsis-v.talk-ellipsis(if={reply_to.reply_to?})

	// mk-post(if={reply_to?})

	article(lang={user.lang})
		a.avatar-anchor(href= config.url + '/' + {user.username})
			img.avatar(src={user.avatar_url}, alt='icon', data-user-card={user.username})
		div.main
			header
				div.left
					a.name(href= config.url + '/' + {user.username})
						| {user.name}
					span.username
						| @{user.username}
				div.right
					a.time
						| {created_at}
			div.body
				div.text
					| {text}
			footer
				button: i.fa.fa-reply
				button: i.fa.fa-retweet
				button: i.fa.fa-plus
				button: i.fa.fa-ellipsis-h

	// i.fa.fa-ellipsis-v.replies-ellipsis(if={replies_count > 0})

script.
	@title = 'a'

	@favorite = (e) ->
		alert \favorited

style.
	display block
	position relative
	margin 0
	padding 12px 0
	font-family 'Meiryo', 'メイリオ', 'sans-serif'
	background #fff
	background-clip padding-box

	> article
		position relative
		padding 16px 32px 6px 32px

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
				width 58px
				height 58px
				margin 0
				border-radius 8px
				vertical-align bottom

		> .main
			float left
			width calc(100% - 74px)

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
					right 32px

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

			> footer
				> button
					padding 8px
					background transparent
					border none
					box-shadow none
					font-size 1em
