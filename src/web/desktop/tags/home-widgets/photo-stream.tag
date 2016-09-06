mk-photo-stream-home-widget
	p.title
		i.fa.fa-camera
		| フォトストリーム
	p.initializing(if={ initializing })
		| 読み込んでいます...
	div.stream(if={ !initializing && images.length > 0 })
		virtual(each={ image in images })
			div.img(style={ 'background-image: url(' + image.url + '?thumbnail&size=256)' })
	p.empty(if={ !initializing && images.length == 0 })
		| 写真はありません

style.
	display block
	position relative
	background #fff

	> .title
		position relative
		z-index 1
		margin 0
		padding 16px
		line-height 1em
		font-weight bold
		color #888
		box-shadow 0 1px rgba(0, 0, 0, 0.07)

		> i
			margin-right 4px
	
	> .stream
		display -webkit-flex
		display -moz-flex
		display -ms-flex
		display flex
		justify-content center
		flex-wrap wrap
		position relative
		padding 4px

		> .img
			flex 1 1 33%
			box-sizing border-box
			width 33%
			height 80px
			background-position center center
			background-size cover
			border solid 4px #fff

	> .initializing
	> .empty
		margin 0
		padding 16px
		text-align center
		color #aaa

script.
	@mixin \stream

	@images = []
	@initializing = true

	@on \mount ~>
		@stream.on \drive_file_created @on-stream-drive-file-created

		api \drive/stream do
			type: 'image/*'
			limit: 9images
		.then (images) ~>
			@initializing = false
			@images = images
			@update!

	@on \unmount ~>
		@stream.off \drive_file_created @on-stream-drive-file-created

	@on-stream-drive-file-created = (file) ~>
		if /^image\/.+$/.test file.type
			@images.unshift file
			if @images.length > 9
				@images.pop!
			@update!