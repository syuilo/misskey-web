# Autocomplete
#================================

get-caret-coordinates = require 'textarea-caret-position'
riot = require 'riot'

# オートコンプリートを管理するクラスです。
class Autocomplete

	@textarea = null
	@suggestion = null

	# 対象のテキストエリアを与えてインスタンスを初期化します。
	(textarea) ~>
		@textarea = textarea

	# このインスタンスにあるテキストエリアの入力のキャプチャを開始します。
	attach: ~>
		@textarea.add-event-listener \input @on-input

	# このインスタンスにあるテキストエリアの入力のキャプチャを解除します。
	detach: ~>
		@textarea.remove-event-listener \input @on-input
		@close!

	# テキスト入力時
	on-input: ~>
		caret = @textarea.selection-start
		text = @textarea.value.substr 0 caret

		mention-index = text.last-index-of \@

		if mention-index == -1
			return

		username = text.substr mention-index + 1

		if not username.match /^[a-zA-Z0-9-]+$/
			return

		@open \user username

	# サジェストを提示します。
	open: (type, q) ~>
		# 既に開いているサジェストは閉じる
		@close!

		# サジェスト要素作成
		@suggestion = document.create-element \mk-autocomplete-suggestion

		# ~ サジェストを表示すべき位置を計算 ~

		caret-position = get-caret-coordinates @textarea, @textarea.selection-start

		rect = @textarea.get-bounding-client-rect!

		x = rect.left + window.page-x-offset + caret-position.left
		y = rect.top + window.page-y-offset + caret-position.top

		@suggestion.style.left = x + \px
		@suggestion.style.top = y + \px

		# マウント
		riot.mount (document.body.append-child @suggestion), do
			textarea: @textarea
			type: type
			q: q

	# サジェストを閉じます。
	close: ~>
		if !@suggestion?
			return

		@suggestion.parent-node.remove-child @suggestion

module.exports = Autocomplete
