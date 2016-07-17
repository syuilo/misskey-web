mk-go-top
	button.hidden(title='一番上へ')
		i.fa.fa-angle-up

script.

	$ window .on 'load scroll resize' @on-scroll

	@on-scroll = ~>
		if $ window .scroll-top! > 500px
			$ \#misskey-go-top-button .remove-class \hidden
		else
			$ \#misskey-go-top-button .add-class \hidden
