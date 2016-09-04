mk-notifications-home-widget
	p.title 通知
	button(onclick={ settings }, title='通知の設定'): i.fa.fa-cog
	div.notifications(if={ notifications.length != 0 })
		virtual(each={ notification in notifications })
			div.notification.like(if={ notification.type == 'like' })
				time { notification.created_at }
				div.main
					a.avatar-anchor
						img.avatar(src={ notification.user.avatar_url + '?thumbnail&size=48' }, alt='avatar')
					div.text
						p
							i.fa.fa-thumbs-o-up
							a(href= config.url + '/' + { notification.user.username }) { notification.user.name }
						a.post-preview { notification.post.text }
	p.empty(if={ notifications.length == 0 })
		| ありません！

style.
	display block
	position relative
	background #fff

	> .title
		margin 0
		padding 16px
		line-height 1em
		font-weight bold
		color #888
		border-bottom solid 1px #eee
	
	> button
		position absolute
		top 0
		right 0
		padding 16px
		font-size 1em
		line-height 1em
		color #ccc

		&:hover
			color #aaa
		
		&:active
			color #999
	
	> .notifications
		> .notification
			position relative
			margin 0
			padding 16px
			font-size 0.9em
			border-bottom solid 1px rgba(0, 0, 0, 0.05)

			&:last-child
				border-bottom none

			&:after
				content ""
				display block
				clear both

			> time
				display inline
				position absolute
				top 16px
				right 12px
				vertical-align top
				color rgba(0, 0, 0, 0.6)
				font-size small

			> .main
				word-wrap break-word
		
			.avatar-anchor
				img
					float left
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
						color #55ACEE
		
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

			&.mention
				.post-preview
					color rgba(0, 0, 0, 0.7)

	> .empty
		margin 0
		padding 16px
		text-align center
		color #aaa

script.
	@mixin \stream

	@notifications = []

	@on \mount ~>
		api \i/notifications
		.then (notifications) ~>
			@notifications = notifications
			@update!
		.catch (err, text-status) ->
			console.error err
		
		@stream.on \notification @on-notification
	
	@on \unmount ~>
		@stream.off \notification @on-notification
	
	@on-notification = (notification) ~>
		console.log notification
		@notifications.unshift notification
		@update!

	@settings = ~>
		w = document.body.append-child document.create-element \mk-settings-window
		w-controller = riot.observable!
		riot.mount w, do
			controller: w-controller
		w-controller.trigger \switch \notification
		w-controller.trigger \open
