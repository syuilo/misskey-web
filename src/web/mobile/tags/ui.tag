mk-ui
	div.global@global
		mk-ui-header@header
		mk-ui-nav@nav

		div.content
			<yield />

	mk-stream-indicator

style.
	display block

script.

	@ui.on \notification (text) ~>
		alert text

	@ui.on \set-root-layout ~>
		@set-root-layout!

	@set-root-layout = ~>
		@root.style.padding-top = @header.client-height + \px

	@on \mount ~>
		@set-root-layout!
