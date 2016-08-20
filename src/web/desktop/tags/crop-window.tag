mk-crop-window
	mk-window(controller={ window-controller }, is-modal={ true }, width={ '800px' })
		<yield to="header">
		i.fa.fa-crop
		| { parent.title }
		</yield>
		<yield to="content">
		div.body
			img@img(src={ parent.image.url + '?thumbnail&quality=80' }, alt='')
		div.action
			button.skip(onclick={ parent.skip }) クロップをスキップ
			button.cancel(onclick={ parent.cancel }) キャンセル
			button.ok(onclick={ parent.ok }) 決定
		</yield>

style.
	display block

	> mk-window
		[data-yield='header']
			> i
				margin-right 4px

		[data-yield='content']

			> .body
				> img
					width 100%
					max-height 400px

			.cropper-modal {
				opacity: 0.8;
			}

			.cropper-view-box {
				outline-color: $theme-color;
			}

			.cropper-line, .cropper-point {
				background-color: $theme-color;
			}

			.cropper-bg {
				-webkit-animation: cropper-bg 0.5s linear infinite;
				-moz-animation: cropper-bg 0.5s linear infinite;
				-ms-animation: cropper-bg 0.5s linear infinite;
				animation: cropper-bg 0.5s linear infinite;
			}

			@-webkit-keyframes cropper-bg {
				0% {
					background-position: 0 0;
				}

				100% {
					background-position: -8px -8px;
				}
			}

			@-moz-keyframes cropper-bg {
				0% {
					background-position: 0 0;
				}

				100% {
					background-position: -8px -8px;
				}
			}

			@-ms-keyframes cropper-bg {
				0% {
					background-position: 0 0;
				}

				100% {
					background-position: -8px -8px;
				}
			}

			@keyframes cropper-bg {
				0% {
					background-position: 0 0;
				}

				100% {
					background-position: -8px -8px;
				}
			}

script.
	@mixin \cropper

	@controller = @opts.controller
	@image = @opts.file
	@title = @opts.title
	@cropper = null
	@window-controller = riot.observable!

	@on \mount ~>
		@img = @tags['mk-window'].img
		@cropper = new @Cropper @img, do
			aspect-ratio: 1 / 1
			highlight: no
			view-mode: 1

	@controller.on \open ~>
		@window-controller.trigger \open

	@ok = ~>
		@cropper.get-cropped-canvas!.to-blob (blob) ~>
			@controller.trigger \cropped blob
