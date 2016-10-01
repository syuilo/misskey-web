riot = require 'riot'

ev = riot.observable!

riot.mixin \i do
	init: ->
		@I = window.I
		@on \mount ~>
			ev.on \update ~>
				@update do
					I: window.I
	update-i: (data) ->
		if data?
			window.I = Object.assign window.I, data
		ev.trigger \update
