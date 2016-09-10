mk-nav-home-widget
	a(href= CONFIG.urls.about) Misskeyについて
	i ・
	a(href= CONFIG.urls.about + '/status') ステータス
	i ・
	a(href='https://github.com/syuilo/misskey-web') リポジトリ
	i ・
	a 開発者
	i ・
	a デバッガ

style.
	display block
	padding 16px
	font-family 'Meiryo', 'メイリオ', sans-serif
	font-size 0.9em
	color #aaa
	background #fff

	a
		color #999

	i
		color #ccc
