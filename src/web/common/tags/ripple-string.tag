mk-ripple-string
	<yield/>

style.
	display inline

	> span
		animation ripple-string 4s infinite ease-in-out both

	@keyframes ripple-string
		0%, 80%, 100%
			opacity 1
		40%
			opacity 0.5

script.
	@on \mount ~>
		text = @root.innerHTML
		@root.innerHTML = ''
		(text.split '').for-each (c, i) ~>
			ce = document.create-element \span
			ce.innerHTML = c
			ce.style.animation-delay = (i / 10) + 's'
			@root.append-child ce
