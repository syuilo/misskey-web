mk-select-file-from-drive-window
	mk-window(controller={ window-controller }, is-modal={ true }, is-child={ opts.is-child }, width={ '800px' }, height={ '500px' })
		<yield to="header">
		i.fa.fa-file-o
		| ファイルを選択
		</yield>
		<yield to="content">
		// Note: Riot3.0.0にしたら xmultiple を multiple に変更 (2.xでは、真理値属性と判定され__がプレフィックスされてしまう)
		mk-drive-browser(controller={ parent.browser-controller }, xmultiple={ parent.multiple })
		div
			button.ok(onclick={ parent.ok }) 決定
		</yield>

style.
	> mk-window
		[data-yield='header']
			> i
				margin-right 4px

		[data-yield='content']
			> mk-drive-browser
				height calc(100% - 72px)

			> div
				height 72px
				background lighten($theme-color, 95%)

				button
					-webkit-appearance none
					-moz-appearance none
					appearance none
					display block
					position absolute
					bottom 16px
					cursor pointer
					box-sizing border-box
					padding 0
					margin 0
					width 120px
					height 40px
					font-size 1em
					outline none
					border-radius 4px
					box-shadow none

					&:focus
						&:after
							content ""
							pointer-events none
							position absolute
							top -5px
							right -5px
							bottom -5px
							left -5px
							border-radius 8px

				> .cancel
					right 148px
					color #888
					background linear-gradient(to bottom, #ffffff 0%, #f5f5f5 100%)
					border solid 1px #e2e2e2

					&:hover
						background linear-gradient(to bottom, #f9f9f9 0%, #ececec 100%)
						border-color #dcdcdc

					&:active
						background #ececec
						border-color #dcdcdc

					&:focus
						&:after
							border 2px solid rgba($theme-color, 0.3)

				> .ok
					right 16px
					font-weight bold
					color $theme-color-foreground
					background linear-gradient(to bottom, lighten($theme-color, 25%) 0%, lighten($theme-color, 10%) 100%)
					border solid 1px lighten($theme-color, 15%)

					&:hover
						background linear-gradient(to bottom, lighten($theme-color, 8%) 0%, darken($theme-color, 8%) 100%)
						border-color $theme-color

					&:active
						background $theme-color
						border-color $theme-color

					&:focus
						&:after
							border 2px solid rgba($theme-color, 0.3)

script.
	@file = []

	@controller = @opts.controller
	@multiple = if @opts.multiple? then @opts.multiple else false

	@window-controller = riot.observable!
	@browser-controller = riot.observable!

	@controller.on \open ~>
		@window-controller.trigger \open

	@controller.on \close ~>
		@window-controller.trigger \close

	@browser-controller.on \selected (file) ~>
		@file = file
		@ok!

	@browser-controller.on \change-selection (files) ~>
		@file = files

	@cancel = ~>
		@opts.controller.trigger \close

	@ok = ~>
		@controller.trigger \selected @file
		@window-controller.trigger \close
