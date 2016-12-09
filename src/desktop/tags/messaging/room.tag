mk-messaging-room
	div.stream
		p.initializing(if={ init })
			i.fa.fa-spinner.fa-spin
			| 読み込み中
		p.empty(if={ !init && messages.length == 0 })
			i.fa.fa-info-circle
			| このユーザーとまだ会話したことがありません
		virtual(each={ message, i in messages })
			mk-messaging-message(message={ message })
			p.date(if={ i != messages.length - 1 && message._date != messages[i + 1]._date })
				span { messages[i + 1]._datetext }

	div.typings
	form
		div.grippie(title='ドラッグしてフォームの広さを調整')
		textarea@text(placeholder='ここにメッセージを入力')
		div.uploads
		div.files
		button.submit(type='button', onclick={ say }, disabled={ saying }, title='メッセージを送信')
			i.fa.fa-paper-plane(if={ !saying })
			i.fa.fa-spinner.fa-spin(if={ saying })
		button.attach-from-local(type='button', title='PCから画像を添付する')
			i.fa.fa-upload
		button.attach-from-drive(type='button', title='アルバムから画像を添付する')
			i.fa.fa-folder-open
		input(name='file', type='file', accept='image/*')

style.
	display block

	> .stream
		position absolute
		top 0
		left 0
		width 100%
		height calc(100% - 100px)
		overflow auto

		> .empty
			width 100%
			margin 0
			padding 16px 8px 8px 8px
			text-align center
			font-size 0.8em
			color rgba(0, 0, 0, 0.4)

			i
				margin-right 4px

		> .no-history
			display block
			margin 0
			padding 16px
			text-align center
			font-size 0.8em
			color rgba(0, 0, 0, 0.4)

			i
				margin-right 4px

		> .message
			// something

		> .date
			display block
			margin 8px 0
			text-align center

			&:before
				content ''
				display block
				position absolute
				height 1px
				width 90%
				top 16px
				left 0
				right 0
				margin 0 auto
				background rgba(0, 0, 0, 0.1)

			> span
				display inline-block
				margin 0
				padding 0 16px
				//font-weight bold
				line-height 32px
				color rgba(0, 0, 0, 0.3)
				background #fff

	> form
		position absolute
		z-index 2
		bottom 0
		width 600px
		max-width 100%
		margin 0 auto
		padding 0
		background rgba(255, 255, 255, 0.95)
		background-clip content-box

		.grippie
			height 10px
			margin-top -10px
			background transparent
			cursor ns-resize

			&:hover
				//background rgba(0, 0, 0, 0.1)

			&:active
				//background rgba(0, 0, 0, 0.2)

		textarea
			cursor auto
			display block
			width 100%
			min-width 100%
			max-width 100%
			height 64px
			margin 0
			padding 8px
			font-size 1em
			color #000
			outline none
			border none
			border-top solid 1px #eee
			border-radius 0
			box-shadow none
			background transparent

		.submit
			position absolute
			bottom 0
			right 0
			margin 0
			padding 10px 14px
			line-height 1em
			font-size 1em
			color #aaa
			transition color 0.1s ease

			&:hover
				color $theme-color

			&:active
				color darken($theme-color, 10%)
				transition color 0s ease

		.files
			display block
			margin 0
			padding 0 8px
			list-style none

			&:after
				content ''
				display block
				clear both

			> li
				display block
				float left
				margin 4px
				padding 0
				width 64px
				height 64px
				background-color #eee
				background-repeat no-repeat
				background-position center center
				background-size cover
				cursor move

				&:hover
					> .remove
						display block

				> .remove
					display none
					position absolute
					right -6px
					top -6px
					margin 0
					padding 0
					background transparent
					outline none
					border none
					border-radius 0
					box-shadow none
					cursor pointer

		.attach-from-local
		.attach-from-drive
			margin 0
			padding 10px 14px
			line-height 1em
			font-size 1em
			font-weight normal
			text-decoration none
			color #aaa
			transition color 0.1s ease

			&:hover
				color $theme-color

			&:active
				color darken($theme-color, 10%)
				transition color 0s ease

		input[type=file]
			display none

script.
	@mixin \api
	@mixin \messaging-stream

	@user = @opts.user
	@init = true
	@saying = false
	@messages = []

	@on \mount ~>
		@messaging-stream.connect @user.id
		@messaging-stream.event.on \message @on-message
		@messaging-stream.event.on \read @on-read

		@api \messaging/messages do
			user_id: @user.id
		.then (messages) ~>
			@init = false
			@messages = messages.reverse!
			@update!
		.catch (err) ~>
			console.error err

	@on \unmount ~>
		@messaging-stream.close!

	@on \update ~>
		@messages.for-each (message) ~>
			date = (new Date message.created_at).get-date!
			month = (new Date message.created_at).get-month! + 1
			message._date = date
			message._datetext = month + '月 ' + date + '日'

	@say = ~>
		@saying = true
		@api \messaging/messages/create do
			user_id: @user.id
			text: @refs.text.value
		.then (message) ~>
			# something
		.catch (err) ~>
			console.error err
		.then ~>
			@saying = false
			@update!

	@on-message = (message) ~>
		console.log message
		@messages.push message
		@update!

	@on-read = (ids) ~>
		console.log ids
		if not Array.isArray ids then ids = [ids]
		ids.for-each (id) ~>
			if (@messages.some (x) ~> x.id == id)
				exist = (@messages.map (x) -> x.id).index-of id
				@messages[exist].is_read = true
				@update!
