mk-core-error
	i: i.fa.fa-times-circle
	h1 サーバーに接続できません
	p.text インターネット回線に問題があるか、サーバーがダウンまたはメンテナンスしている可能性があります。しばらくしてから再度お試しください。
	p.thanks いつもMisskeyをご利用いただきありがとうございます。

style.
	position fixed
	z-index 16384
	top 0
	left 0
	width 100%
	height 100%
	text-align center
	background #fff

	> i
		display block
		margin-top 64px
		font-size 5em
		color #69a087
	
	> h1
		display block
		margin 32px auto 16px auto
		font-size 1.5em
		color #555

	> .text
		display block
		margin 0 auto
		max-width 600px
		font-size 1.4em
		color #666
	
	> .thanks
		display block
		margin 32px auto 0 auto
		padding 32px 0 32px 0
		max-width 600px
		font-size 1.2em
		font-style italic
		color #aaa
		border-top solid 1px #eee
