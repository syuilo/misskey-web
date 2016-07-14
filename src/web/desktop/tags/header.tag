mk-header
	div.main
		div.main-contents-container
			div.left
				nav
					div.misskey-menu
						button.hamburger
							span.bar(role='presentation')
							span.bar(role='presentation')
							span.bar(role='presentation')
					div.main-nav
						ul
							if signin
								li.home.active: a(href= config.url)
									i.fa.fa-home
									p ホーム
								li.mentions: a(href= config.url + '/i/mentions')
									i.fa.fa-at
									p あなた宛て
								li.talks: a(href= config.talkUrl)
									i.fa.fa-comments
									p トーク
			div.right
				form.search(action= config.searchUrl, method='get', role='search')
					input(type='search', name='q', placeholder!='&#xf002; 検索')
					div.result
				div.account(if='{SIGNIN}')
					div.bg(role='presentation')
					button.header(data-active='false')
						span.username
							| {USER.username}
							i.fa.fa-angle-down
						img.avatar(src='{USER.avatar_url + \'?size=64\'}', alt='avatar')
					div.body(style={display: 'none'})
						ul
							li: a.ui-waves-effect(href= config.url + '/{USER.username}')
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
				div.post(if='{SIGNIN}')
					button#misskey-post-button(title='新規投稿')
						i.fa.fa-pencil-square-o
				mk-header-clock

	style(type='stylus', scoped).
		@import "../../base";

		$ui-controll-background-color = #fffbfb;
		$ui-controll-foreground-color = #ABA49E;

		:scope
			position fixed
			top 0
			z-index 1024
			width 100%
			box-shadow 0 0 1px rgba(0, 0, 0, 0)

			> .main
				margin 0
				padding 0
				color $ui-controll-foreground-color
				background-color $ui-controll-background-color
				//background-image url("/_resources/common/images/misskey.dark.svg")
				background-repeat no-repeat
				background-position center center
				background-size auto 24px
				background-clip content-box
				font-size 0.9rem

				&, *
					user-select none
					-moz-user-select none
					-webkit-user-select none
					-ms-user-select none
					cursor default

				&:after
					content ""
					display block
					clear both

				> .main-contents-container {
					width: 100%;
					max-width: 1300px;
					margin: 0 auto;

					> .left {
						float: left;
						height: 3rem;

						> nav {
							> .main-nav {
								display: inline-block;
								margin: 0;
								padding: 0;
								line-height: 3rem;
								vertical-align: top;

								> ul {
									display: inline-block;
									margin: 0;
									padding: 0;
									vertical-align: top;
									line-height: 3rem;
									list-style: none;

									> li {
										display: inline-block;
										vertical-align: top;
										height: 48px;
										line-height: 48px;
										background-clip: padding-box !important;

										&.active {
											background: $theme-color;

											> a {
												color: $theme-color-foreground !important;
												border-bottom: none !important;

												&:hover {
													border-bottom: none !important;
												}
											}
										}

										> a {
											display: inline-block;
											box-sizing: border-box;
											z-index: 1;
											height: 100%;
											padding: 0 24px;
											font-size: 1em;
											font-variant: small-caps;
											color: $ui-controll-foreground-color;
											text-decoration: none;
											transition: none;
											cursor: pointer;

											* {
												pointer-events: none;
											}

											&:hover {
												color: darken($ui-controll-foreground-color, 20%);
											}

											&:active {
											}

											> i {
												margin-right: 8px;
											}

											> p {
												display: inline;
												margin: 0;
											}

											> .unread-count {
												display: inline;
												margin-left: 8px;
												padding: 2px 4px;
												font-size: 0.8em;
												color: $theme-color-foreground;
												background: $theme-color;
												border-radius: 2px;
											}
										}
									}
								}
							}
						}
					}

					> .right {
						float: right;
						height: 48px;

						> .search {
							display: block;
							float: left;
							position: relative;

							> input {
								-webkit-appearance: none;
								-moz-appearance: none;
								appearance: none;
								user-select: text;
								-moz-user-select: text;
								-webkit-user-select: text;
								-ms-user-select: text;
								cursor: auto;
								box-sizing: border-box;
								margin: 0;
								padding: 6px 18px;
								width: 14em;
								height: 48px;
								font-size: 1em;
								line-height: calc(48px - 12px);
								background: transparent;
								outline: none;
								//border: solid 1px #ddd;
								border: none;
								border-radius: 0;
								box-shadow: none;
								transition: color 0.5s ease, border 0.5s ease;
								font-family: FontAwesome, 'Helvetica','Arial','Hiragino Kaku Gothic ProN','ヒラギノ角ゴ ProN W3','Meiryo UI','Meiryo, メイリオ','sans-serif';

								&[data-active='true'] {
									background: #fff;
								}

								&::-webkit-input-placeholder,
								&:-ms-input-placeholder,
								&:-moz-placeholder {
									color: $ui-controll-foreground-color;
								}
							}

						}

						> .account {
							display: block;
							float: left;
							position: relative;

							> .bg {
								display: block;
								position: fixed;
								top: 48px;
								left: 0;
								z-index: -1;
								width: 100%;
								height: 100%;
								background: rgba(0, 0, 0, 0.5);
								opacity: 0;
								pointer-events: none;
								transition: opacity 1s cubic-bezier(0, 1, 0, 1);

								&[data-show=true] {
									opacity: 1;
									pointer-events: auto;
								}
							}

							&[data-active='true'] {
								> .header {
									background: #fff;

									> .avatar {
										filter: saturate(200%);
										-webkit-filter: saturate(200%);
										-moz-filter: saturate(200%);
										-o-filter: saturate(200%);
										-ms-filter: saturate(200%);
									}
								}
							}

							> .header {
								-webkit-appearance: none;
								-moz-appearance: none;
								appearance: none;
								display: block;
								margin: 0;
								padding: 0;
								color: $ui-controll-foreground-color;
								border: none;
								background: transparent;
								cursor: pointer;

								* {
									pointer-events: none;
								}

								&:hover {
									color: darken($ui-controll-foreground-color, 20%);
								}

								&:active {
									color: darken($ui-controll-foreground-color, 30%);
								}

								> .screen-name {
									display: block;
									float: left;
									margin: 0 12px 0 16px;
									max-width: 16em;
									line-height: 48px;
									font-weight: bold;
									text-decoration: none;

									i {
										margin-left: 8px;
									}
								}

								> .avatar {
									display: block;
									float: left;
									box-sizing: border-box;
									min-width: 32px;
									max-width: 32px;
									min-height: 32px;
									max-height: 32px;
									margin: 8px 8px 8px 0;
									border-radius: 4px;
								}
							}

							> .body {
								display: block;
								position: absolute;
								z-index: -1;
								right: 0;
								width: 256px;
								background: #fff;
								transition: top 1s cubic-bezier(0, 1, 0, 1);
								font-family: 'Proxima Nova Reg', "FOT-スーラ Pro M", 'Hiragino Kaku Gothic ProN', 'ヒラギノ角ゴ ProN W3', 'Meiryo', 'メイリオ', sans-serif;

								ul {
									display: block;
									margin: 16px 0;
									padding: 0;
									list-style: none;

									> li {
										display: block;

										> a {
											display: block;
											position: relative;
											z-index: 1;
											padding: 16px 32px;
											line-height: 1em;
											color: #868C8C;
											cursor: pointer;

											* {
												pointer-events: none;
											}

											> i:first-of-type {
												margin-right: 0.3em;
											}

											> i:last-of-type {
												display: block;
												position: absolute;
												top: 0;
												right: 8px;
												z-index: 1;
												padding: 0 24px;
												line-height: 42px;
												line-height: calc(1em + 32px);
											}

											&:hover, &:active {
												text-decoration: none;
												background: $theme-color;
												color: $theme-color-foreground;
											}
										}
									}
								}
							}
						}

						> .post {
							display: inline-block;
							box-sizing: border-box;
							padding: 8px;
							height: 100%;
							vertical-align: top;

							> button {
								-webkit-appearance: none;
								-moz-appearance: none;
								appearance: none;
								display: inline-block;
								box-sizing: border-box;
								margin: 0;
								padding: 0 10px;
								height: 100%;
								font-size: 1.2em;
								font-weight: normal;
								text-decoration: none;
								color: $theme-color-foreground;
								background: $theme-color !important;
								outline: none;
								border: none;
								border-radius: 2px;
								box-shadow: none;
								transition: background 0.1s ease;
								cursor: pointer;
								font-family: inherit;

								* {
									pointer-events: none;
								}

								&:hover {
									background: lighten($theme-color, 10%) !important;
								}

								&:active {
									background: darken($theme-color, 10%) !important;
									transition: background 0s ease;
								}
							}
						}

					}
				}
