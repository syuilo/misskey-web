mk-time
	time(datetime={ opts.time }) { text }

script.
	@time = new Date @opts.time
	@tickid = null

	@on \mount ~>
		@tick!
		@tickid = set-interval @tick, 1000ms
	
	@on \unmount ~>
		clear-interval @tickid

	@tick = ~>
		now = new Date!
		ago = ~~((now - @time) / 1000)
		@text = switch
			| ago >= 31536000s => ~~(ago / 31536000s) + '年前'
			| ago >= 2592000s  => ~~(ago / 2592000s)  + 'ヶ月前'
			| ago >= 604800s   => ~~(ago / 604800s)   + '週間前'
			| ago >= 86400s    => ~~(ago / 86400s)    + '日前'
			| ago >= 3600s     => ~~(ago / 3600s)     + '時間前'
			| ago >= 60s       => ~~(ago / 60s)       + '分前'
			| ago >= 10s       => ~~(ago % 60s)       + '秒前'
			| ago <  10s       =>                       'たった今'
			| _ => ''
		@update!