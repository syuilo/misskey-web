mk-new-app-page
	main
		header
			i.fa.fa-plug.fa-3x
			h1 新しいアプリを作成
			p MisskeyのAPIを利用したアプリケーションを作成できます。
		mk-new-app-form

style.
	display block
	padding 64px 0

	> main
		width 100%
		max-width 700px
		margin 0 auto

		> header
			position relative
			margin 0 0 16px 0
			padding 0 0 16px 64px
			border-bottom solid 1px #444

			> i
				display block
				position absolute
				top 0
				left 0
				color #777

			> h1
				margin 0 0 12px 0
				padding 0
				line-height 32px
				font-size 32px
				font-weight normal
				color #999

			> p
				margin 0
				line-height 16px
				color #555
