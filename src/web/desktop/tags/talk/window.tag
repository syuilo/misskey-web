mk-talk-window
	mk-window(controller={ window-controller }, is-modal={ false }, width={ '500px' }, height={ '560px' })
		<yield to="header">
		i.fa.fa-comments
		| トーク
		</yield>
		<yield to="content">
		mk-talk(controller={ parent.talk-controller })
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
	@talk-controller = riot.observable!

	@on \mount ~>
		@window-controller.trigger \open

	@window-controller.on \closed ~>
		@unmount!
