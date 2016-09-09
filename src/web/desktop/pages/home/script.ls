riot = require 'riot'
load = require '../../base.ls'

load ->
	riot.mount 'mk-stream-indicator'

	window.add-event-listener \load follow-sidebar
	window.add-event-listener \scroll follow-sidebar
	window.add-event-listener \resize follow-sidebar

	left = document.get-element-by-id \left
	right = document.get-element-by-id \right

	function follow-sidebar
		window-top = window.scroll-y
		window-height = window.inner-height
		html-height = document.body.offset-height

		follow left
		follow right

		function follow(el)
			body = el.children.0
			top = el.get-bounding-client-rect!.top + window-top
			height = body.offset-height

			overflow = (top + height) - window-height
			if overflow < 0 then overflow = 0
			if window-top + window-height > top + height
				margin = window-top - overflow
				body.style.margin-top = "#{margin}px"
			else
				body.style.margin-top = 0
