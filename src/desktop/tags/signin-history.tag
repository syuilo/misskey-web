mk-signin-history
	div.records(if={ history.length != 0 })
		div(each={ history })
			mk-time(time={ created_at })
			p.ip { ip }
			pre: code { JSON.stringify(headers, null, '    ') }

style.
	display block

	> .records
		> div
			padding 16px 0 0 0
			border-bottom solid 1px #eee

			> .ip
				margin 0

			> mk-time
				position absolute
				top 16px
				right 0

			> pre
				overflow auto
				max-height 100px

				> code
					white-space pre-wrap

script.
	@mixin \api
	@mixin \stream

	@history = []
	@fetching = true

	@on \mount ~>
		@api \i/signin_history
		.then (history) ~>
			@history = history
			@fetching = false
			@update!
		.catch (err) ~>
			console.error err

		@stream.on \signin @on-signin

	@on \unmount ~>
		@stream.off \signin @on-signin

	@on-signin = (signin) ~>
		@history.unshift signin
		@update!
