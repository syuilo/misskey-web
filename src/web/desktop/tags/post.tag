mk-post(tabindex='-1', title={ title })
	//i.fa.fa-ellipsis-v.talk-ellipsis(if={reply_to.reply_to?})

	div.reply-to(if={ post.reply_to })
		mk-post-preview(post={ post.reply_to })

	article
		a.avatar-anchor(href= config.url + '/' + { post.user.username })
			img.avatar(src={ post.user.avatar_url }, alt='icon', data-user-card={ post.user.username })
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
			footer
				button(onclick={ reply }): i.fa.fa-reply
				button(onclick={ repost }): i.fa.fa-retweet
				button: i.fa.fa-plus
				button: i.fa.fa-ellipsis-h

	// i.fa.fa-ellipsis-v.replies-ellipsis(if={replies_count > 0})

style.
	display block
	position relative
	margin 0
	padding 0
	font-family 'Meiryo', 'メイリオ', 'sans-serif'
	background #fff
	background-clip padding-box

	> .reply-to
		padding 0 16px
		background #fcfcfc

		> mk-post-preview
			background #fcfcfc

	> article
		position relative
		padding 28px 32px 18px 32px

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
					top 28px
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
					margin 0 28px 0 0
					padding 8px
					background transparent
					border none
					box-shadow none
					font-size 1em
					color #ddd
					cursor pointer

					&:hover
						color #666

script.
	@post = opts.post
	@title = 'a'

	@reply-form = null
	@reply-form-controller = riot.observable!

	@repost-form = null
	@repost-form-controller = riot.observable!

	@reply = ~>
		if !@reply-form?
			@reply-form = document.body.append-child document.create-element \mk-post-form-window
			riot.mount @reply-form, do
				controller: @reply-form-controller
				reply: @post
		@reply-form-controller.trigger \open

	@repost = ~>
		if !@repost-form?
			@repost-form = document.body.append-child document.create-element \mk-repost-form-window
			riot.mount @repost-form, do
				controller: @repost-form-controller
				post: @post
		@repost-form-controller.trigger \open
