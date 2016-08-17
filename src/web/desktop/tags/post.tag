mk-post(tabindex='-1', title={ title }, class={ repost: is-repost })
	//i.fa.fa-ellipsis-v.talk-ellipsis(if={reply_to.reply_to?})

	div.reply-to(if={ p.reply_to })
		mk-post-preview(post={ p.reply_to })

	div.repost(if={ is-repost })
		p
			a.avatar-anchor(href= config.url + '/' + { post.user.username }): img.avatar(src={ post.user.avatar_url }, alt='avatar', data-user-card={ post.user.username })
			i.fa.fa-retweet
			a.name(href= config.url + '/' + { post.user.username }) { post.user.name }
			| がRepost

	article
		a.avatar-anchor(href= config.url + '/' + { p.user.username })
			img.avatar(src={ p.user.avatar_url }, alt='avatar', data-user-card={ p.user.username })
		div.main
			header
				div.left
					a.name(href= config.url + '/' + { p.user.username })
						| { p.user.name }
					span.username
						| @{ p.user.username }
				div.right
					a.time
						| { p.created_at }
			div.body
				div.text
					| { p.text }
			footer
				button(onclick={ reply }, title='返信'): i.fa.fa-reply
				button(onclick={ repost }, title='Repost'): i.fa.fa-retweet
				button: i.fa.fa-plus
				button: i.fa.fa-ellipsis-h

	// i.fa.fa-ellipsis-v.replies-ellipsis(if={replies_count > 0})

style.
	display block
	position relative
	margin 0
	padding 0
	font-family 'Meiryo', 'メイリオ', sans-serif
	background #fff
	background-clip padding-box
	overflow hidden

	> .repost
		color #9dbb00
		background linear-gradient(to bottom, #edfde2 0%, #fff 100%)

		> p
			margin 0
			padding 16px 32px

			.avatar-anchor
				display inline-block

				.avatar
					vertical-align bottom
					min-width 28px
					min-height 28px
					max-width 28px
					max-height 28px
					margin 0 8px 0 0
					border-radius 6px

			i
				margin-right 4px

			.name
				font-weight bold

		& + article
			padding-top 8px

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

				&:after
					content ""
					display block
					clear both

				> .left
					float left

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
					float right

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
	@is-repost = @post.repost?
	@p = if @is-repost then @post.repost else @post

	@reply-form = null
	@reply-form-controller = riot.observable!

	@repost-form = null
	@repost-form-controller = riot.observable!

	@reply = ~>
		if !@reply-form?
			@reply-form = document.body.append-child document.create-element \mk-post-form-window
			riot.mount @reply-form, do
				controller: @reply-form-controller
				reply: @p
		@reply-form-controller.trigger \open

	@repost = ~>
		if !@repost-form?
			@repost-form = document.body.append-child document.create-element \mk-repost-form-window
			riot.mount @repost-form, do
				controller: @repost-form-controller
				post: @p
		@repost-form-controller.trigger \open
