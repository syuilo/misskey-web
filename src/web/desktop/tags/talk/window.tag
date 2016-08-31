mk-talk-window
	mk-window(controller={ window-controller }, is-modal={ false }, width={ '500px' }, height={ '560px' })
		<yield to="header">
		i.fa.fa-comments
		| トーク
		</yield>
		<yield to="content">
		mk-talk(event={ parent.talk-event })
		</yield>

style.
	> mk-window
		[data-yield='header']
			> i
				margin-right 4px

		[data-yield='content']
			> mk-talk
				height 100%

script.
	@window-controller = riot.observable!
	@talk-event = riot.observable!

	@on \mount ~>
		@window-controller.trigger \open

	@window-controller.on \closed ~>
		@unmount!

	@talk-event.on \navigate-user (user) ~>
		w = document.body.append-child document.create-element \mk-talk-room-window
		riot.mount w, do
			user: user
