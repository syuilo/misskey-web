riot = require 'riot'
require '../../base.ls'
riot.mount 'mk-stream-indicator'

window.add-event-listener \load follow-sidebar
window.add-event-listener \scroll follow-sidebar
window.add-event-listener \resize follow-sidebar

function follow-sidebar
	window-top = window.scroll-y
	window-height = window.inner-height

	left = document.get-element-by-id \left
	left-body = left.children.0
	left-top = left.get-bounding-client-rect!.top + window-top
	left-height = left-body.offset-height

	left-overflow = (left-top + left-height) - window-height
	if left-overflow < 0 then left-overflow = 0
	if window-top + window-height > left-top + left-height
		margin = window-top - left-overflow
		left-body.style.margin-top = "#{margin}px"
	else
		left-body.style.margin-top = 0

	right = document.get-element-by-id \right
	right-body = right.children.0
	right-top = right.get-bounding-client-rect!.top + window-top
	right-height = right-body.offset-height

	right-overflow = (right-top + right-height) - window-height
	if right-overflow < 0 then right-overflow = 0
	if window-top + window-height > right-top + right-height
		margin = window-top - right-overflow
		right-body.style.margin-top = "#{margin}px"
	else
		right-body.style.margin-top = 0