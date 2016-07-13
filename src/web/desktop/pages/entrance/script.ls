$ = require 'jquery'
require 'jquery.transit'

require '../../../base.ls'
WavesEffect = require '../../common/waves-effect.js'
Strength = require '../../common/strength.js'

$ window .load ->
	WavesEffect.attach-to-class \ripple-effect

window.on-recaptchaed = ->
	$ \.recaptcha .find '> .caption > i' .attr \class 'fa fa-toggle-on'

window.on-recaptcha-expired = ->
	$ \.recaptcha .find '> .caption > i' .attr \class 'fa fa-toggle-off'

$ ->
	swing $ 'body > header'

	init-signin-form!
	init-signup-form!

	$ \#new .click go-signup
	$ '#signup-form .cancel' .click go-signin

function go-signup
	$new = $ \#new
	$title = $ \#title
	$description = $ \#description
	$main = $ \main
	$signin-form = $ \#signin-form-container
	$signup-form = $ \#signup-form

	$new.css \pointer-events \none

	$new
		.transition {
			scale: \0.7
			opacity: 0
			duration: 500ms
		}

	$title
		.transition {
			opacity: 0
			duration: 500ms
		}
		.transition {
			opacity: 1
			duration: 500ms
		}

	$main.css \overflow \hidden
	$main.css \height "#{$main.outer-height!}px"
	$main
		.transition {
			width: \434px
			duration: 500ms
		}
		.transition {
			height: ($signup-form.outer-height! + 64px + 2px) + \px
			'margin-top': (-$description.outer-height!) + \px
			duration: 500ms
		}

	$signin-form
		.transition {
			left: \-100%
			opacity: 0
			duration: 500ms
		}

	$signup-form.css \display \block
	$signup-form
		.transition {
			left: \32px
			opacity: 1
			duration: 500ms
		}

	set-timeout do
		->
			$title.text '始めましょう'
			$description
				.transition {
					opacity: 0
					duration: 500ms
				}
		500ms

	set-timeout do
		->
			$description.css \display \none
			$main.css \height \auto
			$main.css \margin-top \0
			$main.css \overflow \visible
			$new.css \display \none
			$signin-form.css \display \none
			$signup-form.css {
				position: \relative
				top: 0
				left: 0
			}

			$signup-form.find '.username > input' .focus!
		1000ms

function go-signin
	$new = $ \#new
	$title = $ \#title
	$description = $ \#description
	$main = $ \main
	$signin-form = $ \#signin-form-container
	$signup-form = $ \#signup-form

	$title
		.transition {
			opacity: 0
			duration: 500ms
		}
		.transition {
			opacity: 1
			duration: 500ms
		}

	$description.css \display \block

	$main.css \overflow \hidden
	$main.css \height "#{$main.outer-height!}px"
	$main.css 'margin-top' (-$description.outer-height!) + \px
	$main
		.transition {
			width: \380px
			duration: 500ms
		}
		.transition {
			height: ($signin-form.outer-height! + $new.outer-height! + 64px + 24px + 2px) + \px
			'margin-top': \0px
			duration: 500ms
		}

	$new.css \display \block

	$signup-form.css \position \absolute
	$signup-form.css \top \32px
	$signup-form
		.css \left \32px
		.transition {
			left: \100%
			opacity: 0
			duration: 500ms
		}

	$signin-form.css \display \block
	$signin-form
		.transition {
			left: \0px
			opacity: 1
			duration: 500ms
		}

	set-timeout do
		->
			$title.text \Misskey

			$description
				.transition {
					opacity: 1
					duration: 500ms
				}

			$main.css \overflow \visible

			$main
				.transition {
					'margin-top': '0px'
					duration: 500ms
				}

			$new.css \pointer-events \auto
			$new
				.transition {
					scale: '1'
					opacity: 1
					duration: 500ms
				}
		500ms

	set-timeout do
		->
			$main.css \height \auto

			$signup-form.css \display \none
			$signin-form.css {
				position: \relative
				top: 0
				left: 0
			}

			$signin-form.find '.username > input' .focus!
		1000ms

function init-signin-form
	$form = $ \#signin

	init-card-effect $form

	$ \#username .change ->
		$.ajax "#{CONFIG.urls.api}/users/show", {
			data: {'screen-name': $ \#username .val!}
		}
		.done (user) ->
			$ '#signin .title p' .text user.name
			$ \#avatar .attr \src user.avatar-thumbnail-url

	$form.submit (event) ->
		event.prevent-default!

		$ \html .add-class \logging

		z = Math.floor(Math.random() * 40) - 20

		$form = $ @
			..css {
				"transform": "perspective(512px) translateY(-100%) scale(0.7) rotateX(-180deg) rotateZ(#{z}deg)",
				"opacity": "0",
				"transition": "all ease-in 0.5s"
			}

		$submit-button = $form.find '[type=submit]'
			..attr \disabled on

		$.ajax CONFIG.urls.signin, {
			data: {
				'screen-name': $form.find '[name="username"]' .val!
				'password': $form.find '[name="password"]' .val!
			}
		}
		.done ->
			location.reload!
		.fail ->
			$ \html .remove-class \logging
			$submit-button.attr \disabled off
			$form.css {
				"transform": "perspective(512px) translateY(0) scale(1)",
				"opacity": "1",
				"transition": "all ease 0.7s"
			}

function init-signup-form
	$form = $ \#signup-form

	$form.find '.username > input' .keyup ->
		un = $form.find '.username > input' .val!
		if un != ''
			err = switch
				| not un.match /^[a-z0-9\-]+$/ => '小文字のa~z、0~9、-(ハイフン)が使えます'
				| un.length < 3chars           => '3文字以上でお願いします！'
				| un.length > 20chars          => '20文字以内でお願いします'
				| _                            => null

			if err
				$form.find '.username > .info'
					..children \i .attr \class 'fa fa-exclamation-triangle'
					..children \span .text err
					..attr \data-state \error
				$form.find '.username > .profile-page-url-preview' .text ""
			else
				$form.find '.username > .info'
					..children \i .attr \class 'fa fa-spinner fa-pulse'
					..children \span .text '確認しています...'
					..attr \data-state \processing
				$form.find '.username > .profile-page-url-preview' .text "#{CONFIG.url}/#un"

				$.ajax "#{CONFIG.urls.api}/username/available" {
					data: {'username': un}
				} .done (result) ->
					if result.available
						$form.find '.username > .info'
							..children \i .attr \class 'fa fa-check'
							..children \span .text '利用できます'
							..attr \data-state \ok
					else
						$form.find '.username > .info'
							..children \i .attr \class 'fa fa-exclamation-triangle'
							..children \span .text '既に利用されています'
							..attr \data-state \error
				.fail (err) ->
					$form.find '.username > .info'
						..children \i .attr \class 'fa fa-exclamation-triangle'
						..children \span .text '通信エラー'
						..attr \data-state \error
		else
			$form.find '.username > .profile-page-url-preview' .text ""

	$form.find '.password > input' .keyup ->
		$meter = $form.find '.password > .meter'
		password = $form.find '.password > input' .val!

		if password != ''
			strength = Strength password
			text = ''

			if strength > 0.3
				text = 'まあまあのパスワード'
				$meter.attr \data-strength \medium

				if strength > 0.7
					text = '強いパスワード'
					$meter.attr \data-strength \high
			else
				text = '弱いパスワード'
				$meter.attr \data-strength \low

			$meter.find '.value' .css \width "#{strength * 100}%"

			if strength < 0.3
				$form.find '.password > .info'
					..children \i .attr \class 'fa fa-exclamation-triangle'
					..children \span .text text
					..attr \data-state \error
			else
				$form.find '.password > .info'
					..children \i .attr \class 'fa fa-check'
					..children \span .text text
					..attr \data-state \ok
		else
			$meter.attr \data-strength ''

	$form.find '.retype-password > input' .keyup ->
		password = $form.find '.password > input' .val!
		retyped-password = $form.find '.retype-password > input' .val!
		if retyped-password != ''
			err = switch
				| retyped-password != password => 'パスワードが一致していません'
				| _                            => null
			if err
				$form.find '.retype-password > .info'
					..children \i .attr \class 'fa fa-exclamation-triangle'
					..children \span .text err
					..attr \data-state \error
			else
				$form.find '.retype-password > .info'
					..children \i .attr \class 'fa fa-check'
					..children \span .text 'OK'
					..attr \data-state \ok

	$form.submit (event) ->
		event.prevent-default!

		$submit-button = $form.find '[type=submit]'
			..attr \disabled on
			..find \span .text 'アカウントを作成中...'
			..find \i .attr \class 'fa fa-spinner fa-pulse'

		$form.find \input .attr \disabled on

		username = $form.find '[name="username"]' .val!
		password = $form.find '[name="password"]' .val!

		$ \html .add-class \logging

		$.ajax "#{CONFIG.urls.api}/account/create" {
			data:
				'username': username
				'password': password
				'g-recaptcha-response': grecaptcha.get-response!
		} .done ->
			$submit-button
				.find \span .text 'サインイン中...'

			location.href = "#{CONFIG.urls.signin}?username=#{username}&password=#{password}"
		.fail ->
			alert '何らかの原因によりアカウントの作成に失敗しました。再度お試しください。'

			grecaptcha.reset!

			$submit-button
				..attr \disabled off
				.find \span .text 'アカウント作成'
				..find \i .attr \class 'fa fa-check'

			$form.find \input .attr \disabled off

			$ \html .remove-class \logging

function init-card-effect($card)
	force = 10
	perspective = 512

	$card.on 'mousedown' (e) ->
		cx = e.page-x - $card.offset!.left
		cy = e.page-y - $card.offset!.top
		w = $card.outer-width!
		h = $card.outer-height!
		cxp = ((cx / w) * 2) - 1
		cyp = ((cy / h) * 2) - 1
		angle = Math.max(Math.abs(cxp), Math.abs(cyp)) * force
		$card
			.css \transition 'transform 0.05s ease'
			.css \transform "perspective(#{perspective}px) rotate3d(#{-cyp}, #{cxp}, 0, #{angle}deg)"

	$card.on 'mouseleave mouseup' (e) ->
		$card
			.css \transition 'transform 1s ease'
			.css \transform "perspective(#{perspective}px) rotate3d(0, 0, 0, 0deg)"

function swing($elem)
	t = 1
	f = 1
	$elem.css \transform-origin 'center top'
	timer = set-interval update, 10ms
	function update
		t++
		f += (1 / f)
		pos = Math.sin(t / 20) / (f / 256)
		$elem.css \transform "perspective(1024px) rotateX(#{pos}deg)"
