mk-repost-form
	mk-window(controller={ opts.controller }, is-modal={ true })
		<yield to="header">
		i.fa.fa-retweet
		| この投稿をRepostしますか？
		</yield>
		<yield to="content">
		mk-post-preview(post={ opts.post })
		div
			button.cancel(onclick={ parent.cancel }) キャンセル
			button.ok Repost
		</yield>

style.
	> mk-window
		[data-yield='header']
			> i
				margin-right 4px

		[data-yield='content']
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
	@cancel = ~>
		@opts.controller.trigger \close
