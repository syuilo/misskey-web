riot = require 'riot'

module.exports = (i) ->

	ev = riot.observable!

	riot.mixin \i do
		init: ->
			@I = i
			@SIGNIN = i?

			@on \mount   ~> ev.on  \update updated.bind @
			@on \unmount ~> ev.off \update updated.bind @

			function updated
				@update do
					I: i

		update-i: (data) ->
			if data?
				i := Object.assign i, data
			ev.trigger \update
