mk-notifications-home-widget
	p.title
		i.fa.fa-bell-o
		| 通知
	button(onclick={ settings }, title='通知の設定'): i.fa.fa-cog
	mk-notifications

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

		> i
			margin-right 4px
	
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

	> mk-notifications
		max-height 300px
		overflow auto

script.
	@settings = ~>
		w = document.body.append-child document.create-element \mk-settings-window
		w-controller = riot.observable!
		riot.mount w, do
			controller: w-controller
		w-controller.trigger \switch \notification
		w-controller.trigger \open
