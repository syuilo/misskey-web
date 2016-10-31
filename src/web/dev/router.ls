# Router
#================================

route = require \page
page = null

module.exports = (me) ~>

	# Routing
	#--------------------------------

	route \/ index
	route \/app apps
	route \/app/new new-app
	route \/:user user.bind null \home
	route \/:user/graphs user.bind null \graphs
	route \/:user/:post post
	route \* not-found

	# Handlers
	#--------------------------------

	function index
		mount document.create-element \mk-index

	function apps
		mount document.create-element \mk-apps-page

	function new-app
		mount document.create-element \mk-new-app-page

	function user page, ctx
		document.create-element \mk-user-page
			..set-attribute \user ctx.params.user
			..set-attribute \page page
			.. |> mount

	function post ctx
		document.create-element \mk-post-page
			..set-attribute \post ctx.params.post
			.. |> mount

	function not-found
		mount document.create-element \mk-not-found

	# Exec
	#--------------------------------

	route!

# Mount
#================================

riot = require \riot

function mount content
	if page? then page.unmount!
	body = document.get-element-by-id \app
	page := riot.mount body.append-child content .0
