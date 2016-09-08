mk-rss-reader-home-widget
	p.title
		i.fa.fa-rss-square
		| RSS
	button(onclick={ settings }, title='設定'): i.fa.fa-cog
	div.feed(if={ !initializing })
		virtual(each={ item in items })
			a(href={ item.link }, target='_blank') { item.title }
	p.initializing(if={ initializing })
		i.fa.fa-spinner.fa-pulse.fa-fw
		| 読み込んでいます...

style.
	display block
	position relative
	background #fff

	> .title
		margin 0
		padding 14px 16px
		line-height 1em
		font-size 0.9em
		font-weight bold
		color #888
		border-bottom solid 1px #eee

		> i
			margin-right 4px
	
	> button
		position absolute
		top 0
		right 0
		padding 14px
		font-size 0.9em
		line-height 1em
		color #ccc

		&:hover
			color #aaa
		
		&:active
			color #999

	> .feed
		padding 12px 16px

		> a
			display block
			padding 4px 0
			color #666
			border-bottom dashed 1px #eee

			&:last-child
				border-bottom none

	> .initializing
		margin 0
		padding 16px
		text-align center
		color #aaa

		> i
			margin-right 4px

script.

	@url = 'http://news.yahoo.co.jp/pickup/rss.xml'
	@items = []
	@initializing = true

	@on \mount ~>
		@fetch!

		set-interval @fetch, 60000ms
	
	@fetch = ~>
		url = CONFIG.url + '/_/api/rss-proxy/' + @url
		fetch url, do
			mode: \cors
		.then (feed) ~>
			feed.json!.then (feed) ~>
				@items = feed.rss.channel.item
				@initializing = false
				@update!
		.catch (err) ->
			console.error err

	@settings = ~>
		NotImplementedException!
