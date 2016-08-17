mk-header-search
	form.search(action= config.searchUrl, method='get', role='search')
		input(type='search', name='q', placeholder!='&#xf002; 検索')
		div.result

style.
	$ui-controll-background-color = #fffbfb
	$ui-controll-foreground-color = #ABA49E

	> form
		display block
		float left
		position relative

		> input
			-webkit-appearance none
			-moz-appearance none
			appearance none
			user-select text
			-moz-user-select text
			-webkit-user-select text
			-ms-user-select text
			cursor auto
			box-sizing border-box
			margin 0
			padding 6px 18px
			width 14em
			height 48px
			font-size 1em
			line-height calc(48px - 12px)
			background transparent
			outline none
			//border solid 1px #ddd
			border none
			border-radius 0
			box-shadow none
			transition color 0.5s ease, border 0.5s ease
			font-family FontAwesome, 'Meiryo UI', 'Meiryo', 'メイリオ', sans-serif

			&[data-active='true']
				background #fff

			&::-webkit-input-placeholder,
			&:-ms-input-placeholder,
			&:-moz-placeholder
				color $ui-controll-foreground-color
