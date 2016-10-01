mk-notifications
	div.notifications(if={ notifications.length != 0 })
		virtual(each={ notification in notifications })
			div.notification(class={ notification.type })
				mk-time(time={ notification.created_at })

				div.main(if={ notification.type == 'like' })
					a.avatar-anchor(href={ CONFIG.url + '/' + notification.user.username }, data-user-preview={ notification.user.id })
						img.avatar(src={ notification.user.avatar_url + '?thumbnail&size=48' }, alt='avatar')
					div.text
						p
							i.fa.fa-thumbs-o-up
							a(href= config.url + '/' + { notification.user.username }, data-user-preview={ notification.user.id }) { notification.user.name }
						a.post-preview(href={ CONFIG.url + '/' + notification.post.user.username + '/' + notification.post.id }) { get-post-summary(notification.post) }

				div.main(if={ notification.type == 'repost' })
					a.avatar-anchor(href={ CONFIG.url + '/' + notification.post.user.username }, data-user-preview={ notification.post.user.id })
						img.avatar(src={ notification.post.user.avatar_url + '?thumbnail&size=48' }, alt='avatar')
					div.text
						p
							i.fa.fa-retweet
							a(href= config.url + '/' + { notification.post.user.username }, data-user-preview={ notification.post.user.id }) { notification.post.user.name }
						a.post-preview(href={ CONFIG.url + '/' + notification.post.user.username + '/' + notification.post.id }) { get-post-summary(notification.post.repost) }

				div.main(if={ notification.type == 'follow' })
					a.avatar-anchor(href={ CONFIG.url + '/' + notification.user.username }, data-user-preview={ notification.user.id })
						img.avatar(src={ notification.user.avatar_url + '?thumbnail&size=48' }, alt='avatar')
					div.text
						p
							i.fa.fa-user-plus
							a(href= config.url + '/' + { notification.user.username }, data-user-preview={ notification.user.id }) { notification.user.name }

	p.empty(if={ notifications.length == 0 && !loading })
		| ありません！
	p.loading(if={ loading })
		i.fa.fa-spinner.fa-pulse.fa-fw
		| 読み込んでいます
		mk-ellipsis

style.
	display block
	
	> .notifications
		> .notification
			position relative
			margin 0
			padding 16px
			font-size 0.9em
			border-bottom solid 1px rgba(0, 0, 0, 0.05)

			&:last-child
				border-bottom none

			> mk-time
				display inline
				position absolute
				top 16px
				right 12px
				vertical-align top
				color rgba(0, 0, 0, 0.6)
				font-size small

			> .main
				word-wrap break-word

			&:after
				content ""
				display block
				clear both

			.avatar-anchor
				display block
				float left

				img
					min-width 36px
					min-height 36px
					max-width 36px
					max-height 36px
					border-radius 6px
		
			.text
				float right
				box-sizing border-box
				width calc(100% - 36px)
				padding-left 8px

				p
					margin 0

					i
						margin-right 4px
		
			&.like, &.repost
				.post-preview
					color rgba(0, 0, 0, 0.7)

					&:before, &:after
						font-family FontAwesome
						font-size 1em
						font-weight normal
						font-style normal
						display inline-block
						margin-right 3px
					
					&:before
						content "\f10d"

					&:after
						content "\f10e"

			&.like
				.text p i
					color #FFAC33

			&.repost
				.text p i
					color #77B255
			
			&.follow
				.text p i
					color #53c7ce

			&.mention
				.post-preview
					color rgba(0, 0, 0, 0.7)

	> .empty
		margin 0
		padding 16px
		text-align center
		color #aaa
	
	> .loading
		margin 0
		padding 16px
		text-align center
		color #aaa

		> i
			margin-right 4px

script.
	@mixin \user-preview

	@mixin \stream
	@mixin \get-post-summary

	@notifications = []
	@loading = true

	@on \mount ~>
		api \i/notifications
		.then (notifications) ~>
			@notifications = notifications
			@loading = false
			@update!
		.catch (err, text-status) ->
			console.error err
		
		@stream.on \notification @on-notification
	
	@on \unmount ~>
		@stream.off \notification @on-notification
	
	@on-notification = (notification) ~>
		@notifications.unshift notification
		@update!
