mk-home
	div.main
		div.left@left
		main
			mk-timeline-home-widget@tl(if={ mode == 'timeline' })
			mk-mentions-home-widget@tl(if={ mode == 'mentions' })
		div.right@right
	mk-detect-slow-internet-connection-notice

style.
	display block

	> .main
		display flex
		justify-content center
		margin 0 auto
		max-width 1200px

		> *
			> *
				display block
				//border solid 1px #eaeaea
				border solid 1px rgba(0, 0, 0, 0.075)
				border-radius 6px
				overflow hidden

				&:not(:last-child)
					margin-bottom 16px

		> main
			flex 2.4
			padding 16px

		> *:not(main)
			flex 1

		> .left
			padding 16px 0 16px 16px

		> .right
			padding 16px 16px 16px 0

		@media (max-width 1050px)
			> *:not(main)
				display none

			> main
				max-width 700px

script.
	@mixin \i
	@mode = @opts.mode || \timeline

	# https://github.com/riot/riot/issues/2080
	if @mode == '' then @mode = \timeline

	@home = []

	@on \mount ~>
		@refs.tl.on \loaded ~>
			@trigger \loaded

		@I.data.home.for-each (widget) ~>
			try
				el = document.create-element \mk- + widget.name + \-home-widget
				switch widget.place
					| \left => @refs.left.append-child el
					| \right => @refs.right.append-child el
				@home.push (riot.mount el, do
					id: widget.id
					data: widget.data
				.0)
			catch e
				# nope

	@on \unmount ~>
		@home.for-each (widget) ~>
			widget.unmount!
