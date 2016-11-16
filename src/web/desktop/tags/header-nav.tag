mk-header-nav: ul(if={ SIGNIN })
	li.home.active: a(href= config.url)
		i.fa.fa-home
		p ホーム
	li.mentions: a(href= config.url + '/i/mentions')
		i.fa.fa-at
		p あなた宛て
	li.messaging: a(href= config.messagingUrl, onclick={ messaging })
		i.fa.fa-comments
		p メッセージ
		i.fa.fa-circle(if={ messaging-notice })
	li.info: a(onclick={ info })
		i.fa.fa-info
		p お知らせ

style.
	$ui-controll-foreground-color = #9eaba8

	display inline-block
	margin 0
	padding 0
	line-height 3rem
	vertical-align top

	> ul
		display inline-block
		margin 0
		padding 0
		vertical-align top
		line-height 3rem
		list-style none

		> li
			display inline-block
			vertical-align top
			height 48px
			line-height 48px
			background-clip padding-box !important

			&.active
				> a
					border-bottom solid 3px $theme-color

			> a
				display inline-block
				box-sizing border-box
				z-index 1
				height 100%
				padding 0 24px
				font-size 1em
				font-variant small-caps
				color $ui-controll-foreground-color
				text-decoration none
				transition none
				cursor pointer

				*
					pointer-events none

				&:hover
					color darken($ui-controll-foreground-color, 20%)
					text-decoration none

				> i:first-child
					margin-right 8px

				> i:last-child
					margin-left 5px
					vertical-align super
					font-size 10px
					color $theme-color

				> p
					display inline
					margin 0

script.
	@mixin \api

	@on \mount ~>
		@api \messaging/unread
		.then (count) ~>
			if count.count > 0
				@messaging-notice = true
				@update!

	@messaging = ~>
		riot.mount document.body.append-child document.create-element \mk-messaging-window

	@info = ~>
		riot.mount document.body.append-child document.create-element \mk-idol-master-cinderella-girls-starlight-stage-information-window
