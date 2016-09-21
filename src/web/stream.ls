# Stream
#================================

ReconnectingWebSocket = require 'reconnecting-websocket'
riot = require 'riot'

function init
	state = riot.observable!
	event = riot.observable!

	socket = new ReconnectingWebSocket CONFIG.api.url.replace \http \ws

	socket.onopen = ~>
		state.trigger \connected
		socket.send JSON.stringify do
			i: I._web

	socket.onclose = ~>
		state.trigger \closed

	socket.onmessage = (message) ~>
		try
			message = JSON.parse message.data
			if message.type?
				event.trigger message.type, message.body
		catch
			# ignore

	{
		state
		event
	}

# Export
#--------------------------------

module.exports = ~> init!
