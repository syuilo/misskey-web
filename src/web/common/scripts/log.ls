module.exports = (msg) ~>
	if SIGNIN && I.data.debug
		console.log msg
