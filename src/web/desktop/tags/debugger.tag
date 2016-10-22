mk-debugger
	mk-window(controller={ window-controller }, is-modal={ false }, width={ '700px' }, height={ '550px' })
		<yield to="header">
		i.fa.fa-wrench
		| Debugger
		</yield>
		<yield to="content">
		section
			h1 progress-dialog
			button(onclick={ parent.progress-dialog }) i.fa.fa-play
			label
				p VAL
				input(type='number', oninput={ parent.progress-change }, value=0)
			label
				p MAX
				input(type='number', oninput={ parent.progress-change }, value=100)
		</yield>

style.
	> mk-window
		[data-yield='header']
			> i
				margin-right 4px

		[data-yield='content']
			overflow auto

			> section
				padding 32px

				//	& + section
				//		margin-top 16px

				> h1
					display block
					margin 0
					padding 0 0 8px 0
					font-size 1em
					color #555
					border-bottom solid 1px #eee

				> label
					display block

					> p
						display inline
						margin 0

script.
	@mixin \open-window

	@window-controller = riot.observable!

	@on \mount ~>
		@window-controller.trigger \open

	@window-controller.on \closed ~>
		@unmount!

	################################

	@progress-dialog = ~>
		@progress-controller = riot.observable!
		@open-window \mk-progress-dialog do
			title: 'Title'
			controller: @progress-controller
