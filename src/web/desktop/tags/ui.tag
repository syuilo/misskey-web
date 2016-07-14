mk-ui
	mk-post-form(core='{core}')

	mk-global(name='global')
		mk-header(name='header', core='{core}')

		mk-contents
			| <yield/>

	mk-go-top

	script.
		@core = riot.observable!

		@core.on \on-modal ~>
			$global = $ @global
			$ {blur-radius: 0} .animate {blur-radius: 5} do
				duration: 100ms
				easing: \linear
				step: ->
					$global.css do
						'-webkit-filter': "blur("+@blur-radius+"px)"
						'-moz-filter':    "blur("+@blur-radius+"px)"
						'filter':         "blur("+@blur-radius+"px)"
