module.exports = ->
	fetch \/meta do
		method: \POST
	.then (res) ~>
		meta <~ res.json!.then
		if meta.commit.hash != VERSION
			if window.confirm '新しいMisskeyのバージョンがあります。更新しますか？'
				location.reload true
