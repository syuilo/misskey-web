# Autocomplete
#================================

get-caret-coordinates = require 'textarea-caret-position'
riot = require 'riot'

module.exports = (el) ~>
	el.add-event-listener \input on-input

	function on-input
		caret = el.selection-start
		text = el.value.substr 0 caret

		mention-index = text.last-index-of \@

		if mention-index == -1
			return

		username = text.substr mention-index + 1

		if not username.match /^[a-zA-Z0-9-]+$/
			return

		open \user username

	function open type, q
		caret-position = get-caret-coordinates el, el.selection-start

		suggestion = document.body.append-child document.create-element \mk-autocomplete-suggestion
		riot.mount suggestion, do
			type: type
			q: q

		# ~ サジェストを表示すべき位置を計算 ~

		rect = el.get-bounding-client-rect!

		x = rect.left + window.page-x-offset + caret-position.left
		y = rect.top + window.page-y-offset + caret-position.top

		suggestion.style.left = x + \px
		suggestion.style.top = y + \px
