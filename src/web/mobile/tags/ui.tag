mk-ui
	div.global@global
		mk-ui-header@header(ready={ ready })
		mk-ui-nav@nav

		div.content@main
			<yield />

	mk-stream-indicator

style.
	display block

script.

	@ready-count = 0

	#@ui.on \notification (text) ~>
	#	alert text

	@on \mount ~>
		@ready!

	@ready = ~>
		@ready-count++

		if @ready-count == 2
			SpSlidemenu @main, @nav, \#hamburger {direction: \left}
			@init-view-position!

	@init-view-position = ~>
		console.log @
		top = @header.offset-height
		@main.style.padding-top = top + \px
		@nav.style.margin-top = top + \px
		#$ '#misskey-nav > .slidemenu-body > .slidemenu-content' .css \padding-bottom top + \px
