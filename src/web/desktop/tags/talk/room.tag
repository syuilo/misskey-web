mk-talk-room
	header(if={ group }): div.container
		div.kyoppie
			h1 { group.name }
			ol.members
				li.member(each={ member in group.members }, title={ member.name }): a
					img.avatar(src={ member.avatar_url + '?thumbnail&size=32' }, alt='')
		div.nav.dropdown
			button
				i.fa.fa-bars
			nav.dropdown-content
				ul.menu(if={ group.owner.id == me.id })
					li: p
						i.fa.fa-cog
						| グループの設定
					li: p
						i.fa.fa-users
						| メンバーの管理
				ul.menu
					li: p.invite
						i.fa.fa-user-plus
						| 招待
					li: p
						i.fa.fa-minus-circle
						| グループを離脱
	div.stream
		p.initializing(if={ init })
			i.fa.fa-spinner.fa-spin
			| 読み込み中
		p.empty(if={ !init && messages.length == 0 })
			i.fa.fa-info-circle
			span(if={ user }) このユーザーとまだ会話したことがありません
			span(if={ group }) このグループにまだ会話はありません
		virtual(each={ message in messages })
			p { message.text }
	div.typings
	form
		div.grippie(title='ドラッグしてフォームの広さを調整')
		textarea(name='text', placeholder='ここにメッセージを入力')
		div.uploads
		div.files
		button(type='submit', title='メッセージを送信')
			i.fa.fa-paper-plane
		button.attach-from-local(type='button', title='PCから画像を添付する')
			i.fa.fa-upload
		button.attach-from-album(type='button', title='アルバムから画像を添付する')
			i.fa.fa-folder-open
		input(name='file', type='file', accept='image/*')

style.
	display block
	position relative

	> header
		display block
		position absolute
		top 0
		left 0
		z-index 2
		width 100%
		background #fff

		> .container
			position relative
			max-width 600px
			width 100%
			margin 0 auto
			padding 0

			> .kyoppie
				display block
				width calc(100% - 48px)
				white-space nowrap
				overflow hidden

				> h1
					display inline-block
					margin 0
					padding 0 16px
					line-height 48px
					font-size 1em
					color #67747D
					vertical-align top


				> .members
					display inline-block
					margin 0
					padding 0
					list-style none

					> .member
						display inline-block
						margin 0
						padding 0

						> a
							display inline-block
							padding 8px 4px

							> .avatar
								display inline-block
								width 32px
								height 32px
								border-radius 100%
								vertical-align top






			> .dropdown
				display block
				position absolute
				top 0
				right 0
				overflow visible

				&[data-active='true']
					background #eee

					> button
						color #111 !important


					> .dropdown-content
						visibility visible



				> button
					-webkit-appearance none
					-moz-appearance none
					appearance none
					display block
					margin 0
					padding 0
					width 48px
					line-height 48px
					font-size 1.5em
					font-weight normal
					text-decoration none
					color #888
					background transparent
					outline none
					border none
					border-radius 0
					box-shadow none
					cursor pointer
					transition color 0.1s ease

					*
						pointer-events none


					&:hover
						color #444



				> .dropdown-content
					visibility hidden
					display block
					position absolute
					top auto
					right 0
					z-index 3
					width 270px
					margin 0
					padding 0
					background #eee

					> ul
						margin 0
						padding 0
						list-style none
						font-size 1em
						border-bottom solid 1px #ddd

						&:last-child
							border-bottom none


						> li
							display inline-block
							width 100%

							> *
								display inline-block
								z-index 1
								box-sizing border-box
								vertical-align top
								width 100%
								margin 0
								padding 12px 20px
								text-decoration none
								color #444
								transition none

								&:hover
									color #fff
									background-color $theme-color


								&:active
									color #fff
									background-color darken($theme-color, 10%)


								> i
									width 2em
									text-align center

	> .stream
		> .empty
			box-sizing border-box
			width 100%
			margin 0
			padding 16px 8px 8px 8px
			text-align center
			font-size 0.8em
			color rgba(0, 0, 0, 0.4)

			i
				margin-right 4px

		> .no-history
			display block
			margin 0
			padding 16px
			text-align center
			font-size 0.8em
			color rgba(0, 0, 0, 0.4)

			i
				margin-right 4px

		> .message
			display block
			position relative
			padding 10px 12px 10px 12px
			background-color transparent

			&:after
				content ""
				display block
				clear both

			&.user-message
			&.group-message
				> .avatar-anchor
					display block

					> .avatar
						display block
						min-width 54px
						min-height 54px
						max-width 54px
						max-height 54px
						margin 0
						border-radius 8px
						transition all 0.1s ease

				> .content-container
					display block
					box-sizing border-box
					position relative
					margin 0 12px
					padding 0
					max-width calc(100% - 78px)

					> .balloon
						display block
						float inherit
						box-sizing border-box
						position relative
						margin 0
						padding 0
						max-width 100%
						min-height 2.1em
						line-height 1.3em
						border-radius 16px

						&:before
							content ""
							pointer-events none
							display block
							position absolute
							top calc(((1.3em + (8px * 2)) / 2) - 8px)

						&:hover
							> .delete-button
								display block

						> .delete-button
							display none
							position absolute
							z-index 1
							top -4px
							right -4px
							margin 0
							padding 0
							cursor pointer
							outline none
							border none
							border-radius 0
							box-shadow none
							background transparent

							> img
								vertical-align bottom
								width 16px
								height 16px
								cursor pointer

						> .read
							display block
							position absolute
							z-index 1
							bottom -4px
							left -12px
							margin 0
							color rgba(0, 0, 0, 0.5)
							font-size 0.7em

						> .content

							> .is-deleted
								display block
								margin 0
								padding 0
								overflow hidden
								word-wrap break-word
								font-size 1em
								color rgba(0, 0, 0, 0.5)

							> .text
								display block
								margin 0
								padding 8px 16px
								overflow hidden
								word-wrap break-word
								font-size 1em
								color rgba(0, 0, 0, 0.8)

								&, *
									user-select text
									-moz-user-select text
									-webkit-user-select text
									-ms-user-select text
									cursor auto

								.url
									color $theme-color
									text-decoration none

									&, *
										cursor pointer

									&:hover
										text-decoration underline

									&:after
										content "\f14c"
										display inline-block
										padding-left 2px
										font-family FontAwesome
										font-size 0.9em
										font-weight normal
										font-style normal

									> .protocol
										opacity 0.5

									> .hostname
										font-weight normal

									> .pathname
										opacity 0.8

									> .hash
										font-style italic

									> .query
										opacity 0.5

								> p
									margin 0

								& + .file
									&.image
										> img
											border-radius 0 0 16px 16px

							> .file
								&.image
									> img
										display block
										max-width 100%
										max-height 512px
										border-radius 16px

					> footer
						display block
						clear both
						margin 0
						padding 2px
						font-size 0.65em
						color rgba(0, 0, 0, 0.4)

						> .is-edited
							margin-left 4px

				&.me
					> .avatar-anchor
						float right

					> .content-container
						float right

						> .balloon
							background $me-balloon-color

							&:before
								right -14px
								border-top solid 8px transparent
								border-right solid 8px transparent
								border-bottom solid 8px transparent
								border-left solid 8px $me-balloon-color

							> .content

								> p.is-deleted
									color rgba(255, 255, 255, 0.5)

								> .text
									color #fff

									.url
										color #fff

						> footer
							text-align right

				&.otherparty
					> .avatar-anchor
						float left

					> .content-container
						float left

						> .balloon
							background #eee

							&:before
								left -14px
								border-top solid 8px transparent
								border-right solid 8px #eee
								border-bottom solid 8px transparent
								border-left solid 8px transparent

						> footer
							text-align left

				&[data-is-deleted='true']
					> .content-container
						opacity 0.5

			&.group-send-invitation-activity
				text-align center
				color #888

				.icon
					display inline-block
					width 32px
					height 32px
					margin-right 8px
					color #fff
					background #ddd
					border-radius 100%

					> i
						line-height 32px

				.invitee
					font-weight bold
					color #888

			&.group-member-join-activity
				text-align center
				color #888

				.avatar
					width 32px
					height 32px
					margin-right 8px
					vertical-align top
					border-radius 100%

				.text
					display inline-block
					line-height 32px
					vertical-align top

					.joiner
						font-weight bold
						color #888

		> .date
			display block
			position relative
			margin 8px 0
			text-align center

			&:before
				content ''
				display block
				position absolute
				height 1px
				width 90%
				top 16px
				left 0
				right 0
				margin 0 auto
				background rgba(0, 0, 0, 0.1)

			> p
				display inline-block
				position relative
				margin 0
				padding 0 16px
				//font-weight bold
				line-height 32px
				color rgba(0, 0, 0, 0.3)
				background #fff

	> form
		position absolute
		z-index 2
		bottom 0
		width 600px
		max-width 100%
		margin 0 auto
		padding 0
		background rgba(255, 255, 255, 0.95)
		background-clip content-box

		&:after
			content ''
			display block
			clear both

		.grippie
			height 10px
			margin-top -10px
			background transparent
			cursor ns-resize

			&:hover
				//background rgba(0, 0, 0, 0.1)

			&:active
				//background rgba(0, 0, 0, 0.2)

		textarea
			user-select text
			-moz-user-select text
			-webkit-user-select text
			-ms-user-select text
			cursor auto
			display block
			box-sizing border-box
			width 100%
			min-width 100%
			max-width 100%
			margin 0
			padding 8px
			font-size 1em
			color #000
			outline none
			border none
			border-top solid 1px #eee
			border-radius 0
			box-shadow none
			background transparent

		[type=submit]
			display inline-block
			float right
			box-sizing border-box
			margin 0
			padding 6px 16px
			min-width 5em
			cursor pointer
			line-height 1.3em
			font-size 1.3em
			font-weight normal
			text-decoration none
			color #fff
			background $theme-color
			outline none
			border none
			border-radius 0
			box-shadow none
			transition background 0.05s ease

			&:hover
				background lighten($theme-color, 10%)

			&:active
				background darken($theme-color, 10%)

			*
				pointer-events none

		.files
			display block
			margin 0
			padding 0 8px
			list-style none

			&:after
				content ''
				display block
				clear both

			> li
				display block
				position relative
				float left
				margin 4px
				padding 0
				width 64px
				height 64px
				background-color #eee
				background-repeat no-repeat
				background-position center center
				//background-size contain
				background-size cover
				cursor move

				&:hover
					> .remove
						display block

				> .remove
					-webkit-appearance none
					-moz-appearance none
					appearance none
					display none
					position absolute
					right -6px
					top -6px
					margin 0
					padding 0
					background transparent
					outline none
					border none
					border-radius 0
					box-shadow none
					cursor pointer

		.attach-from-local
		.attach-from-album
			-webkit-appearance none
			-moz-appearance none
			appearance none
			display block
			float left
			box-sizing border-box
			margin 0
			padding 10px 14px
			line-height 1em
			font-size 1em
			font-weight normal
			text-decoration none
			color #aaa
			background transparent
			outline none
			border none
			border-radius 0
			box-shadow none
			cursor pointer
			transition color 0.1s ease

			*
				pointer-events none

			&:hover
				color $theme-color

			&:active
				color darken($theme-color, 10%)
				transition color 0s ease

		input[type=file]
			display none

script.
	@user = @opts.user
	@group = @opts.group
	@init = true

	@on \mount ~>
		api \talk/messages do
			user: if @user? then @user.id else undefined
			group: if @group? then @group.id else undefined
		.then (messages) ~>
			@init = false
			@messages = messages
			@update!
		.catch (err) ~>
			console.error err
