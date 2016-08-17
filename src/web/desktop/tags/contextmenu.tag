mk-contextmenu
	| <yield />

style.
	display none
	position fixed
	top 0
	left 0
	z-index 4096
	width 240px
	font-size 0.8em
	background #fff
	box-shadow 2px 2px 8px rgba(0, 0, 0, 0.2)

	ul
		display block
		margin 12px 0
		padding 0
		list-style none

		> li
			display block

			> p
				display block
				position relative
				z-index 1
				margin 0
				padding 0 32px 0 38px
				line-height 38px
				color #868C8C
				cursor pointer

				*
					pointer-events none

				> i
					width 28px
					margin-left -28px
					text-align center

				&:hover, &:active
					text-decoration none
					background $theme-color
					color $theme-color-foreground

script.
	@controller = @opts.controller

	@controller.on \open (pos) ~>
		@open pos

	@controller.on \close ~>
		@close!

	@root.add-event-listener \contextmenu (e) ~>
		e.prevent-default!

	@mousedown = (e) ~>
		e.prevent-default!
		if (!contains @root, e.target) and (@root != e.target)
			@close!
		return false

	@open = (pos) ~>
		all = document.query-selector-all 'body *'
		all.for-each (el) ~>
			el.add-event-listener \mousedown @mousedown
		@root.style.display = \block
		@root.style.left = pos.x + \px
		@root.style.top = pos.y + \px

	@close = ~>
		all = document.query-selector-all 'body *'
		all.for-each (el) ~>
			el.remove-event-listener \mousedown @mousedown
		@controller.trigger \closed
		@unmount!

	function contains(parent, child)
		node = child.parent-node
		while (node != null)
			if (node == parent)
				return true
			node = node.parent-node
		return false
