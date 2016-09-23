mk-autocomplete-suggestion
	p { q }

style.
	display block
	position absolute
	z-index 65535
	margin-top calc(1em + 8px)
	background #fff
	background-clip padding-box
	border solid 1px rgba(0, 0, 0, 0.1)
	border-radius 2px

script.
	@q = @opts.q

	@on \mount ~>
		console.log @opts
