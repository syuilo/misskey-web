mk-post-form
	div@bg
	div@container: form@form
		textarea@text
		button(onclick={post}) 投稿

style.
	[name='bg']
	[name='container']
		display none
		position fixed
		top 0
		width 100%
		height 100%

	[name='bg']
		z-index 127
		left 0
		background rgba(0, 0, 0, 0.7)
		opacity 0

	[name='container']
		z-index 1024

	[name='form']
		display block
		position absolute
		top 15%
		right 0
		left 0
		width 100%
		max-width 530px
		margin auto
		background #fff
		opacity 0

script.
	@is-open = false

	@opts.core.on \toggle-post-form ~>
		@toggle!

	@toggle = ~>
		if @is-open
			@close!
		else
			@open!

	@open = ~>
		@is-open = true
		@opts.core.trigger \on-blur

		$bg = $ @bg
		$container = $ @container
		$form = $ @form

		$bg
			.css do
				'display': \block
				'pointer-events': ''
			.animate {
				opacity: 1
			} 100ms \linear

		$container.css do
			'display': \block
			'pointer-events': ''

		$form
			.stop!
			.css \transform 'scale(1.2)'
			.transition {
				opacity: \1
				scale: \1
			} 1000ms 'cubic-bezier(0, 1, 0, 1)'

	@close = ~>
		@is-open = false
		@opts.core.trigger \off-blur

		$bg = $ @bg
		$container = $ @container
		$form = $ @form

		$bg
			.css \pointer-events \none
			.animate {
				opacity: 0
				} 100ms \linear -> $bg.css \display \none

		$container.css \pointer-events \none

		$form
			.stop!
			.transition {
				opacity: \0
				scale: \0.8
			} 1000ms 'cubic-bezier(0, 1, 0, 1)' ->
				if ($form.css \opacity) === '0'
					$container.css \display \none

	@post = (e) ~>
		$.ajax CONFIG.urls.api + '/posts/create' { data: {
			'text': @text.value
		}}
		.done (data) ->
			console.log data
		.fail (err, text-status) ->
			console.error err
