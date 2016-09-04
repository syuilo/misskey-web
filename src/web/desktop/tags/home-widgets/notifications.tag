mk-notifications-home-widget
	p.title 通知
	button(onclick={ settings }, title='通知の設定'): i.fa.fa-cog
	div.notification(if={ notifications.length != 0 }, each={ notification in notifications })
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
	
	> button
		position absolute
		top 0
		right 0
		padding 16px
		font-size 1em
		line-height 1em
		color #bbb

		&:hover
			color #aaa
		
		&:active
			color #999

	> .empty
		margin 0
		padding 16px
		text-align center
		color #aaa
		border-top solid 1px #eee

script.
	@notifications = []

	@settings = ~>
		w = document.body.append-child document.create-element \mk-settings-window
		w-controller = riot.observable!
		riot.mount w, do
			controller: w-controller
		w-controller.trigger \switch \notification
		w-controller.trigger \open
