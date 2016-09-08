mk-broadcast-home-widget
	svg.icon(height='32', version='1.1', viewBox='0 0 16 16', width='32')
		path(d='M4.79 6.11c.25-.25.25-.67 0-.92-.32-.33-.48-.76-.48-1.19 0-.43.16-.86.48-1.19.25-.26.25-.67 0-.92a.613.613 0 0 0-.45-.19c-.16 0-.33.06-.45.19-.57.58-.85 1.35-.85 2.11 0 .76.29 1.53.85 2.11.25.25.66.25.9 0zM2.33.52a.651.651 0 0 0-.92 0C.48 1.48.01 2.74.01 3.99c0 1.26.47 2.52 1.4 3.48.25.26.66.26.91 0s.25-.68 0-.94c-.68-.7-1.02-1.62-1.02-2.54 0-.92.34-1.84 1.02-2.54a.66.66 0 0 0 .01-.93zm5.69 5.1A1.62 1.62 0 1 0 6.4 4c-.01.89.72 1.62 1.62 1.62zM14.59.53a.628.628 0 0 0-.91 0c-.25.26-.25.68 0 .94.68.7 1.02 1.62 1.02 2.54 0 .92-.34 1.83-1.02 2.54-.25.26-.25.68 0 .94a.651.651 0 0 0 .92 0c.93-.96 1.4-2.22 1.4-3.48A5.048 5.048 0 0 0 14.59.53zM8.02 6.92c-.41 0-.83-.1-1.2-.3l-3.15 8.37h1.49l.86-1h4l.84 1h1.49L9.21 6.62c-.38.2-.78.3-1.19.3zm-.01.48L9.02 11h-2l.99-3.6zm-1.99 5.59l1-1h2l1 1h-4zm5.19-11.1c-.25.25-.25.67 0 .92.32.33.48.76.48 1.19 0 .43-.16.86-.48 1.19-.25.26-.25.67 0 .92a.63.63 0 0 0 .9 0c.57-.58.85-1.35.85-2.11 0-.76-.28-1.53-.85-2.11a.634.634 0 0 0-.9 0z')
	h1 開発者募集中！
	p
		| Misskeyはオープンソースで開発されています。Webのリポジトリは
		a(href='https://github.com/syuilo/misskey-web', target='_blank') こちら

style.
	display block
	padding 10px 10px 10px 50px
	background transparent
	border-color #4078c0 !important
	font-family 'Meiryo', 'メイリオ', sans-serif

	&:after
		content ""
		display block
		clear both

	> .icon
		display block
		position relative
		float left
		margin-left -40px
		fill currentColor
		color #4078c0

	> h1
		margin 0
		font-size 0.95em
		font-weight normal
		color #4078c0

	> p
		display block
		z-index 1
		margin 0
		font-size 0.7em
		color #555

		a
			color #555
