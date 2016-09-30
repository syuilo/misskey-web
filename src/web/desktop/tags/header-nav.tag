mk-header-nav: ul(if={ SIGNIN })
	li.home.active: a(href= config.url)
		i.fa.fa-home
		p ホーム
	li.mentions: a(href= config.url + '/i/mentions')
		i.fa.fa-at
		p あなた宛て
	li.talks: a(href= config.talkUrl, onclick={ talk })
		i.fa.fa-comments
		p トーク
	li.talks: a(onclick={ info })
		i.fa.fa-info
		p お知らせ

style.
	$ui-controll-foreground-color = #9eaba8

	display inline-block
	margin 0
	padding 0
	line-height 3rem
	vertical-align top

	> ul
		display inline-block
		margin 0
		padding 0
		vertical-align top
		line-height 3rem
		list-style none

		> li
			display inline-block
			vertical-align top
			height 48px
			line-height 48px
			background-clip padding-box !important

			&.active
				> a
					border-bottom solid 3px $theme-color

			> a
				display inline-block
				box-sizing border-box
				z-index 1
				height 100%
				padding 0 24px
				font-size 1em
				font-variant small-caps
				color $ui-controll-foreground-color
				text-decoration none
				transition none
				cursor pointer

				*
					pointer-events none

				&:hover
					color darken($ui-controll-foreground-color, 20%)
					text-decoration none

				> i
					margin-right 8px

				> p
					display inline
					margin 0

script.
	@talk = ~>
		riot.mount document.body.append-child document.create-element \mk-talk-window

	@info = ~>
		riot.mount document.body.append-child document.create-element \mk-idol-master-cinderella-girls-starlight-stage-information-window
