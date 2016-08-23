mk-post(tabindex='-1', title={ title }, class={ repost: is-repost })
	//i.fa.fa-ellipsis-v.talk-ellipsis(if={reply_to.reply_to?})

	div.reply-to(if={ p.reply_to })
		mk-post-preview(post={ p.reply_to })

	div.repost(if={ is-repost })
		p
			a.avatar-anchor(href= config.url + '/' + { post.user.username }): img.avatar(src={ post.user.avatar_url + '?thumbnail&size=32' }, alt='avatar', data-user-card={ post.user.username })
			i.fa.fa-retweet
			a.name(href= config.url + '/' + { post.user.username }) { post.user.name }
			| がRepost

	article
		a.avatar-anchor(href= config.url + '/' + { p.user.username })
			img.avatar(src={ p.user.avatar_url + '?thumbnail&size=64' }, alt='avatar', data-user-card={ p.user.username })
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
				div.text@text
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
	//overflow hidden

	&:focus
		z-index 1

		&:after
			content ""
			pointer-events none
			position absolute
			top -4px
			right -4px
			bottom -4px
			left -4px
			border 2px solid rgba($theme-color, 0.3)
			border-radius 4px

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

	@on \mount ~>
		@text.innerHTML = @parse-text @p.text

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

	@parse-text = (text) ~>
		if !text?
			return null
		return analyzeHashtags(analyzeMentions(analyzeUrl(analyzeStrike(analyzeBold(escapeHtml(text)))))).replace(/(\r\n|\r|\n)/g, '<br>');

		function escapeHtml(text) {
			return text.replace(/>/g,'&gt;').replace(/</g,'&lt;');
		}

		function analyzeUrl(text) {
			'use strict';
			return text.replace(/https?:(\/\/(([-.0-9_a-z~]|%[0-9a-f][0-9a-f]|[!$&-,:;=])*@)?(\[(([0-9a-f]{1,4}:){6}([0-9a-f]{1,4}:[0-9a-f]{1,4}|(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5]))|::([0-9a-f]{1,4}:){5}([0-9a-f]{1,4}:[0-9a-f]{1,4}|(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5]))|([0-9a-f]{1,4})?::([0-9a-f]{1,4}:){4}([0-9a-f]{1,4}:[0-9a-f]{1,4}|(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5]))|(([0-9a-f]{1,4}:)?[0-9a-f]{1,4})?::([0-9a-f]{1,4}:){3}([0-9a-f]{1,4}:[0-9a-f]{1,4}|(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5]))|(([0-9a-f]{1,4}:){0,2}[0-9a-f]{1,4})?::([0-9a-f]{1,4}:){2}([0-9a-f]{1,4}:[0-9a-f]{1,4}|(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5]))|(([0-9a-f]{1,4}:){0,3}[0-9a-f]{1,4})?::[0-9a-f]{1,4}:([0-9a-f]{1,4}:[0-9a-f]{1,4}|(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5]))|(([0-9a-f]{1,4}:){0,4}[0-9a-f]{1,4})?::([0-9a-f]{1,4}:[0-9a-f]{1,4}|(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5]))|(([0-9a-f]{1,4}:){0,5}[0-9a-f]{1,4})?::[0-9a-f]{1,4}|(([0-9a-f]{1,4}:){0,6}[0-9a-f]{1,4})?::|v[0-9a-f]+\.[!$&-.0-;=_a-z~]+)\]|(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])|([-.0-9_a-z~]|%[0-9a-f][0-9a-f]|[!$&-,;=])*)(:\d*)?(\/([-.0-9_a-z~]|%[0-9a-f][0-9a-f]|[!$&-,:;=@])*)*|\/(([-.0-9_a-z~]|%[0-9a-f][0-9a-f]|[!$&-,:;=@])+(\/([-.0-9_a-z~]|%[0-9a-f][0-9a-f]|[!$&-,:;=@])*)*)?|([-.0-9_a-z~]|%[0-9a-f][0-9a-f]|[!$&-,:;=@])+(\/([-.0-9_a-z~]|%[0-9a-f][0-9a-f]|[!$&-,:;=@])*)*)?(\?([-.0-9_a-z~]|%[0-9a-f][0-9a-f]|[!$&-,\/:;=?@])*)?(#([-.0-9_a-z~]|%[0-9a-f][0-9a-f]|[!$&-,\/:;=?@])*)?/gi, function(url) {
				return '<a href="' + url + '" title="' + url + '" target="_blank" class="url" rel="nofollow">' + url + '</a>';
			});
		}
		function analyzeMentions(text) {
			'use strict';
			return text.replace(/@([a-zA-Z0-9\-]+)/g, function(arg, screenName) {
				return '<a href="' + config.url + '/' + screenName + '" class="mention" data-user-card="' + screenName + '">@' + screenName + '</a>';
			});
		}

		function analyzeBold(text) {
			'use strict';
			return text.replace(/\*\*(.+?)\*\*/g, function(arg, boldee) {
				return '<strong>' + boldee + '</strong>';
			});
		}
		function analyzeHashtags(text) {
			'use strict';
			return text.replace(/(^|\s)#(\S+)/g, function(arg, _, tag) {
				return _ + '<a href="' + config.url + '/search/hashtag:' + tag + '" class="hashtag">#' + tag + '</a>';
			});
		}
