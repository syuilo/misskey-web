mk-search-page
	mk-ui: mk-search(query={ parent.opts.query }, event={ parent.event })

style.
	display block

script.
	@mixin \ui
	@mixin \ui-progress

	@event = riot.observable!

	@on \mount ~>
		document.title = '検索: ' + @opts.query + ' | Misskey'
		# TODO: クエリをHTMLエスケープ
		@ui.trigger \title '<i class="fa fa-search"></i>' + @opts.query

		@Progress.start!

	@event.on \loaded ~>
		@Progress.done!
