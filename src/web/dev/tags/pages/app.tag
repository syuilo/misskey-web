mk-app-page
	main
		header
			h1 { app.name }

style.
	display block

script.
	@mixin \api

	@on \mount ~>
		@api \app/show do
			id: @opts.app
		.then (app) ~>
			@app = app
			@update!
