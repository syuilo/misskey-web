mk-post-form-dialog
	div.bg
	div.form
		header
			h1 新規投稿
			button.close(onclick={ close }): i.fa.fa-times
		mk-post-form(controller={ controller })

style.
	display block

	> .bg
		position fixed
		z-index 2047
		top 0
		left 0
		width 100%
		height 100%
		background rgba(#000, 0.5)

	> .form
		position absolute
		z-index 2048
		top 16px
		left 16px
		box-sizing border-box
		width calc(100% - 32px)
		overflow hidden
		background #fff
		border-radius 8px
		box-shadow 0 0 16px rgba(#000, 0.3)

		> header
			border-bottom solid 1px #eee

			> h1
				margin 0
				padding 0
				text-align center
				line-height 42px
				font-size 1em
				font-weight normal

			> .close
				position absolute
				top 0
				right 0
				line-height 42px
				width 42px

script.
	@controller = riot.observable!

	@close = ~>
		@unmount!

	@controller.on \post ~>
		@unmount!
