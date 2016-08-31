mk-talk-room-window
	mk-window(controller={ window-controller }, is-modal={ false }, width={ '500px' }, height={ '560px' })
		<yield to="header">
		i.fa.fa-comments
		| トーク: { parent.user.name }
		</yield>
		<yield to="content">
		mk-talk-room(user={ parent.user })
		</yield>

style.
	> mk-window
		[data-yield='header']
			> i
				margin-right 4px

		[data-yield='content']
			> mk-talk-room
				height 100%

script.
	@window-controller = riot.observable!
	@user = @opts.user

	@on \mount ~>
		@window-controller.trigger \open

	@window-controller.on \closed ~>
		@unmount!
