mk-notifications-home-widget
	p.title 通知
	div.notification(if={ notifications.length != 0 }, each={ notification in notifications })
	p.empty(if={ notifications.length == 0 })
		| ありません！

style.
	display block
	background #fff

	> .title
		margin 0
		padding 16px
		font-weight bold
		color #888

	> .empty
		margin 0
		padding 16px
		text-align center
		color #aaa
		border-top solid 1px #eee

script.
	@notifications = []