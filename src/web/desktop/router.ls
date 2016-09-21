# Router
#================================

route = require \page

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
	body = document.get-element-by-id \kyoppie
	if body.first-child? then body.remove-child body.first-child
	riot.mount body.append-child content
