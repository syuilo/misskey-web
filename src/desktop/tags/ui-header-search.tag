mk-ui-header-search
	form.search(onsubmit={ onsubmit })
		input@q(type='search', placeholder!='&#xf002; 検索')
		div.result

style.
	$ui-controll-foreground-color = #9eaba8

	> form
		display block
		float left

		> input
			user-select text
			cursor auto
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
			transition color 0.5s ease, border 0.5s ease
			font-family FontAwesome, sans-serif

			&::-webkit-input-placeholder,
				color $ui-controll-foreground-color

script.
	@mixin \page

	@onsubmit = ~>
		@page '/search:' + @q.value
