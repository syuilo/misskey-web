module.exports = (e) ->
	console.error e
	document.body.innerHTML = '<div id="error"><p>致命的な問題が発生しました。</p></div>'
