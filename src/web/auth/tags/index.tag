mk-index
	main
		p.fetching(if={ fetching })
			| 読み込み中
			mk-ellipsis
		mk-form(if={ state == null && !fetching }, session={ session-promise }, event={ event })
		div.denied(if={ state == 'denied' })
			h1 アプリケーションの連携をキャンセルしました。
			p このアプリがあなたのアカウントにアクセスすることはありません。
		div.accepted(if={ state == 'accepted' })
			h1 アプリケーションの連携を許可しました。
			p アプリケーションに戻って作業を続行してください。

style.
	display block

	> main
		width 100%
		max-width 500px
		margin 0 auto
		text-align center
		background #fff
		box-shadow 0px 4px 16px rgba(0, 0, 0, 0.2)

		> .fetching
			margin 0
			padding 32px
			color #555

		> div
			> h1
				margin 0
				padding 0
				font-size 20px
				font-weight normal

			&.denied > h1
				color #e65050

			&.accepted > h1
				color #50bbe6

script.
	@mixin \api

	@state = null
	@fetching = true

	@event = riot.observable!

	@token = window.location.href.split \/ .pop!

	@session-promise = new Promise (resolve, reject) ~>
		@api \auth/session/show do
			token: @token
		.then (session) ~>
			@fetching = false
			@update!
			resolve session

	@event.on \denied ~>
		@state = \denied
		@update!

	@event.on \accepted ~>
		@state = \accepted
		@update!
