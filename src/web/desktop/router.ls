# Router
#================================

route = require \page
page = null

# Routing
#--------------------------------

route \/ index
route \/:user user

# Handlers
#--------------------------------

function index
	if SIGNIN then home! else entrance!

function home
	mount document.create-element \mk-home-page

function entrance
	mount document.create-element \mk-entrance

function user ctx
	document.create-element \mk-user-page
		..set-attribute \user ctx.params.user
		.. |> mount

# Export
#--------------------------------

module.exports = ~> route!

# Mount
#================================

riot = require \riot

function mount content
	if page? then page.unmount!
	body = document.get-element-by-id \kyoppie
	page := riot.mount body.append-child content .0
