mk-talk
	div.search
			div.form
				label(for='search-input')
					i.fa.fa-search
				input@search-input(type='search', oninput={ search }, placeholder='ユーザーを探してトークを開始', title='ユーザー名を入力してユーザーを探します')
			div.result
				ol.users(if={ search-result.length > 0 })
					li(each={ user in search-result })
						a
							img.avatar(src={ user.avatar_url + '?thumbnail&size=32' }, alt='')
							span.name { user.name }
							span.username @{ user.username }
	div.main
		div.history(if={ history.length > 0 })
			virtual(each={ message in history })
				p a
		p.no-history(if={ history.length == 0 })
			| 履歴はありません。
			br
			| ユーザーを検索して、いつでもトークを開始できます。
	nav
		ul
			li.active: a
				i.fa.fa-clock-o
				p 履歴
			li: a(href='/i/users')
				i.fa.fa-user
				p ユーザー
			li: a(href='/i/groups')
				i.fa.fa-users
				p グループ

style.
	display block

	> .search
		display block
		box-sizing border-box
		position absolute
		top 0
		left 0
		z-index 1
		width 100%
		background #fff
		box-shadow 0 0px 2px rgba(0, 0, 0, 0.2)

		> .form
			position relative
			padding 8px
			background #f7f7f7

			> label
				display block
				position absolute
				top 0
				left 8px
				height 100%
				width 1em
				padding 0 16px
				pointer-events none

				> i
					display block
					position absolute
					top 0
					right 0
					bottom 0
					left 0
					width 1em
					height 1em
					margin auto
					color #555

			> input
				box-sizing border-box
				margin 0
				padding 0 12px 0 38px
				width 100%
				font-size 1em
				line-height 38px
				color #000
				outline none
				border solid 1px #eee
				border-radius 5px
				box-shadow none
				transition color 0.5s ease, border 0.5s ease

				&:hover
					border solid 1px #ddd
					transition border 0.2s ease

				&:focus
					color darken($theme-color, 20%)
					border solid 1px $theme-color
					transition color 0, border 0

		> .result
			display block
			position relative
			top 0
			left 0
			z-index 2
			width 100%
			margin 0
			padding 0
			background #fff

			> .users
				margin 0
				padding 0
				list-style none

				> li
					> a
						display inline-block
						z-index 1
						box-sizing border-box
						width 100%
						padding 8px 32px
						vertical-align top
						white-space nowrap
						overflow hidden
						color rgba(0, 0, 0, 0.8)
						text-decoration none
						transition none

						&:hover
							color #fff
							background $theme-color

							.name
								color #fff

							.username
								color #fff

						&:active
							color #fff
							background darken($theme-color, 10%)

							.name
								color #fff

							.username
								color #fff

						.avatar
							vertical-align middle
							min-width 32px
							min-height 32px
							max-width 32px
							max-height 32px
							margin 0 8px 0 0
							border-radius 6px

						.name
							margin 0 8px 0 0
							/*font-weight bold*/
							font-weight normal
							color rgba(0, 0, 0, 0.8)

						.username
							font-weight normal
							color rgba(0, 0, 0, 0.3)

	> .main
		padding-top 56px

		> .talks
			margin 0
			padding 0
			list-style none

			> .talk
				position relative
				padding 0
				background #fff
				border-bottom solid 1px #eee

				&:hover
					background #fafafa

					> a > article > header > h2
						color $theme-color

					> a > article > .avatar
						filter saturate(200%)
						-webkit-filter saturate(200%)
						-moz-filter saturate(200%)
						-o-filter saturate(200%)
						-ms-filter saturate(200%)

				&:active
					background #eee

				&[data-is-unread='false']
				&[data-is-my-message='true']
					opacity 0.8

				&[data-is-unread='true'] > a > article
					//background-image url("/resources/desktop/pages/i/talks-widget/unread.svg")
					background-repeat no-repeat
					background-position 0 center

				> a
					display block
					text-decoration none

					> article
						position relative
						padding 20px 30px

						&:after
							content ""
							display block
							clear both

						> header
							margin-bottom 2px
							white-space nowrap
							overflow hidden

							> h2
								text-align left
								display inline
								margin 0
								padding 0
								font-size 1em
								color rgba(0, 0, 0, 0.9)
								font-weight bold
								transition all 0.1s ease

							> time
								position absolute
								top 16px
								right 16px
								display inline
								color rgba(0, 0, 0, 0.5)
								font-size small

				&.user
					> a
						> article

							> header

								> .screen-name
									text-align left
									margin 0 0 0 8px
									color rgba(0, 0, 0, 0.5)

							> .avatar
								float left
								width 54px
								height 54px
								margin 0 18px 4px 0
								border-radius 8px
								transition all 0.1s ease

							> .body

								> .text
									display block
									margin 0 0 0 0
									padding 0
									overflow hidden
									word-wrap break-word
									font-size 1.1em
									color rgba(0, 0, 0, 0.8)

									.me
										color rgba(0, 0, 0, 0.4)

								> .image
									display block
									max-width 100%
									max-height 512px

				&.group
					> a
						> article

							> header

								> .members-count
									text-align left
									margin 0 0 0 8px
									color rgba(0, 0, 0, 0.5)

							> .mark
								$stroke = 2px
								position absolute
								top 17px
								left 21px
								text-shadow 0 $stroke 0 #fff, $stroke 0 0 #fff, 0 -$stroke 0 #fff, -$stroke 0 0 #fff, -$stroke -$stroke 0 #fff, $stroke -$stroke 0 #fff, -$stroke $stroke 0 #fff, $stroke $stroke 0 #fff
								color #9FA7A6

							> .icon
								float left
								width 54px
								height 54px
								margin 0 18px 4px 0
								border-radius 8px
								transition all 0.1s ease

							> .body

								> .text
									display block
									margin 0 0 0 0
									padding 0
									overflow hidden
									word-wrap break-word
									font-size 1.1em
									color rgba(0, 0, 0, 0.8)

									.me
										color rgba(0, 0, 0, 0.4)

								> .image
									display block
									max-width 100%
									max-height 512px

		> .no-history
			margin 0
			padding 2em 1em
			text-align center
			color #999
			font-family '游ゴシック', 'YuGothic', 'ヒラギノ角ゴ ProN W3', 'Hiragino Kaku Gothic ProN', 'Meiryo UI', 'Meiryo', 'メイリオ', sans-serif
			font-weight 500

	> nav
		display block
		position absolute
		bottom 0
		left 0
		width 100%
		background #F7F7F7
		background-clip content-box
		border-top solid 1px rgba(0, 0, 0, 0.075)

		&, *
			user-select none
			-moz-user-select none
			-webkit-user-select none
			-ms-user-select none
			cursor default

		> ul
			display -webkit-flex
			display -moz-flex
			display -ms-flex
			display -o-flex
			display flex
			justify-content center
			position relative
			margin 0
			padding 0
			list-style none

			> li
				display block
				flex 1 1
				text-align center

				&.active
					> a
						border-top solid 2px $theme-color

				> a
					display block
					padding 8px 8px 10px 8px
					color rgba(0, 0, 0, 0.5)
					border-top solid 2px transparent
					cursor pointer
					transition none

					&:hover
						text-decoration none
						background #fff

					&:active
						background #ECECEC

					*
						pointer-events none

					> i
						font-size 1.5em

					> p
						margin 0
						font-size 0.7em

script.
	@search-result = []

	@on \mount ~>
		api \talk/history
		.then (history) ~>
			@is-loading = false
			@history = history
			@update!
		.catch (err) ~>
			console.error err

	@search = ~>
		q = @search-input.value
		if q == ''
			@search-result = []
		else
			api \users/search do
				query: q
			.then (users) ~>
				@search-result = users
				@update!
			.catch (err) ~>
				console.error err