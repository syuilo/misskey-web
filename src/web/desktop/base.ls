require '../base.ls'
riot = require 'riot'
require 'velocity'

riot.mixin \dialog do
	dialog: (title, text, buttons, can-through, on-through) ~>
		dialog = document.body.append-child document.create-element \mk-dialog
		controller = riot.observable!
		riot.mount dialog, do
			controller: controller
			title: title
			text: text
			buttons: buttons
			can-through: can-through
			on-through: on-through
		controller.trigger \open
		return controller

riot.mixin \input-dialog do
	input-dialog: (title, placeholder, default-value, on-ok, on-cancel) ~>
		dialog = document.body.append-child document.create-element \mk-input-dialog
		riot.mount dialog, do
			title: title
			placeholder: placeholder
			default: default-value
			on-ok: on-ok
			on-cancel: on-cancel

riot.mixin \cropper do
	Cropper: require 'cropper'
