require '../../../base.ls'
window.$ = require 'jquery'

window.moment = require 'moment'

riot = require 'riot'
require '../../tags/post.tag'
require '../../tags/analog-clock.tag'
require '../../tags/header.tag'
require '../../tags/post-form.tag'
require '../../tags/header-clock.tag'
ui = require '../../tags/ui.tag'

$ ->
	riot.mount ui

is-active = yes
unread-count = 0

module.exports = (type) ->
	$ window .on 'load scroll resize' ->
		window-top = $ window .scroll-top!
		window-height = window.inner-height

		if $ \#left-contents .length != 0
			$left = $ \#left-contents
			$left-body = $left.children \.body
			left-top = $left.offset!.top
			left-height = $left-body.outer-height!

			left-overflow = (left-top + left-height) - window-height
			if left-overflow < 0 then left-overflow = 0
			if window-top + window-height > left-top + left-height
				margin = window-top - left-overflow
				#if margin + $left-body.outer-height! > $ document .height! - 64
				#	$left-body.css \margin-top "#{($ document .height! - 64) - $left-body.outer-height!}px"
				#else
				#	$left-body.css \margin-top "#{margin}px"
				$left-body.css \margin-top "#{margin}px"
			else
				$left-body.css \margin-top 0

		if $ \#right-contents .length != 0
			$right = $ \#right-contents
			$right-body = $right.children \.body
			right-top = $right.offset!.top
			right-height = $right-body.outer-height!

			right-overflow = (right-top + right-height) - window-height
			if right-overflow < 0 then right-overflow = 0
			if window-top + window-height > right-top + right-height
				margin = window-top - right-overflow
				#if margin + $right-body.outer-height! > $ document .height! - 64
				#	$right-body.css \margin-top "#{($ document .height! - 64) - $right-body.outer-height!}px"
				#else
				#	$right-body.css \margin-top "#{margin}px"
				$right-body.css \margin-top "#{margin}px"
			else
				$right-body.css \margin-top 0

	$ ->
		try
			Notification.request-permission!
		catch
			console.log 'oops'

		default-title = document.title

		$ document .keydown (e) ->
			tag = e.target.tag-name.to-lower-case!
			if tag != \input and tag != \textarea
				if e.which == 84 # t
					$ '#widget-timeline > .timeline > .posts > .post:first-child' .focus!

		$ window .focus ->
			is-active := yes
			unread-count := 0
			document.title = default-title

		$ window .blur ->
			is-active := no

		# Read more automatically
		if USER_SETTINGS.read-timeline-automatically
			$ window .on \scroll ->
				current = $ window .scroll-top! + window.inner-height
				if current > $ document .height! - 16 # 遊び
					read-more!

		$ \body .append $ "<p class=\"streaming-info\"><i class=\"fa fa-spinner fa-spin\"></i>#{LOCALE.sites.desktop.common.connecting_stream}</p>"

		socket = io.connect CONFIG.streaming-url + '/streaming/' + type

		socket.on \connect ->
			$ 'body > .streaming-info' .remove!
			$message = $ "<p class=\"streaming-info\"><i class=\"fa fa-check\"></i>#{LOCALE.sites.desktop.common.connected_stream}</p>"
			$ \body .append $message
			set-timeout ->
				$message.animate {
					opacity: 0
				} 200ms \linear ->
					$message.remove!
			, 1000ms

		socket.on \disconnect (client) ->
			if $ 'body > .streaming-info.reconnecting' .length == 0
				$ 'body > .streaming-info' .remove!
				$message = $ "<p class=\"streaming-info reconnecting\"><i class=\"fa fa-spinner fa-spin\"></i>#{LOCALE.sites.desktop.common.reconnecting_stream}</p>"
				$ \body .append $message
