mk-ui-header
	div.main
		div.backdrop
		div.content
			button.nav#hamburger: i.fa.fa-bars
			h1 Misskey

style.
	$height = 42px

	display block
	position fixed
	top 0
	z-index 1024
	width 100%
	border-bottom solid 1px rgba(#000, 0.1)

	> .main
		position relative
		color #777

		> .backdrop
			position absolute
			top 0
			z-index 1023
			width 100%
			height $height
			-webkit-backdrop-filter blur(12px)
			backdrop-filter blur(12px)
			background-color rgba(255, 255, 255, 0.75)

		> .content
			position relative
			z-index 1024

			> h1
				display block
				box-sizing border-box
				margin 0 auto
				padding 0
				width 100%
				max-width calc(100% - 112px)
				text-align center
				font-size 1.1em
				font-weight normal
				line-height $height
				white-space nowrap
				overflow hidden
				text-overflow ellipsis

				i
					margin-right 8px

			> .nav
				display block
				position absolute
				top 0
				left 0
				width $height
				font-size 1.4em
				line-height $height
				border-right solid 1px rgba(#000, 0.1)

				> i
					transition all 0.2s ease

script.
	@on \mount ~>
		@opts.ready!
