mk-header-account
	div.bg(role='presentation')
	button.header(data-active='false')
		span.username
			| {USER.username}
			i.fa.fa-angle-down
		img.avatar(src={USER.avatar_url + '?size=64'}, alt='avatar')
	div.body(show={false})
		ul
			li: a.ui-waves-effect(href= config.url + '/' + {USER.username})
				i.fa.fa-user
				| プロフィール
				i.fa.fa-angle-right
			li: a.ui-waves-effect(href= config.url + '/i/drive')
				i.fa.fa-cloud
				| ドライブ
				i.fa.fa-angle-right
			li: a.ui-waves-effect(href= config.url + '/{USER.username}/likes')
				i.fa.fa-star
				| お気に入り
				i.fa.fa-angle-right
		ul
			li: a.ui-waves-effect(href= config.url + '/i/settings')
				i.fa.fa-cog
				| 設定
				i.fa.fa-angle-right
		ul
			li: a.ui-waves-effect(href= config.signoutUrl)
				i(class='fa fa-power-off')
				| サインアウト
				i.fa.fa-angle-right

style.
	$ui-controll-background-color = #fffbfb
	$ui-controll-foreground-color = #ABA49E

	display block
	float left
	position relative

	> .bg
		display block
		position fixed
		top 48px
		left 0
		z-index -1
		width 100%
		height 100%
		background rgba(0, 0, 0, 0.5)
		opacity 0
		pointer-events none
		transition opacity 1s cubic-bezier(0, 1, 0, 1)

		&[data-show=true]
			opacity 1
			pointer-events auto

	&[data-active='true']
		> .header
			background #fff

			> .avatar
				filter saturate(200%)
				-webkit-filter saturate(200%)
				-moz-filter saturate(200%)
				-o-filter saturate(200%)
				-ms-filter saturate(200%)

	> .header
		-webkit-appearance none
		-moz-appearance none
		appearance none
		display block
		margin 0
		padding 0
		color $ui-controll-foreground-color
		border none
		background transparent
		cursor pointer

		*
			pointer-events none

		&:hover
			color darken($ui-controll-foreground-color, 20%)

		&:active
			color darken($ui-controll-foreground-color, 30%)

		> .screen-name
			display block
			float left
			margin 0 12px 0 16px
			max-width 16em
			line-height 48px
			font-weight bold
			text-decoration none

			i
				margin-left 8px

		> .avatar
			display block
			float left
			box-sizing border-box
			min-width 32px
			max-width 32px
			min-height 32px
			max-height 32px
			margin 8px 8px 8px 0
			border-radius 4px

	> .body
		display block
		position absolute
		z-index -1
		right 0
		width 256px
		background #fff
		transition top 1s cubic-bezier(0, 1, 0, 1)
		font-family 'Proxima Nova Reg', "FOT-スーラ Pro M", 'Hiragino Kaku Gothic ProN', 'ヒラギノ角ゴ ProN W3', 'Meiryo', 'メイリオ', sans-serif

		ul
			display block
			margin 16px 0
			padding 0
			list-style none

			> li
				display block

				> a
					display block
					position relative
					z-index 1
					padding 16px 32px
					line-height 1em
					color #868C8C
					cursor pointer

					*
						pointer-events none

					> i:first-of-type
						margin-right 0.3em

					> i:last-of-type
						display block
						position absolute
						top 0
						right 8px
						z-index 1
						padding 0 24px
						line-height 42px
						line-height calc(1em + 32px)

					&:hover, &:active
						text-decoration none
						background $theme-color
						color $theme-color-foreground
