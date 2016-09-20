page = require 'page'
riot = require 'riot'

function clean
	content = document.get-element-by-id \content
	if content.first-child? then content.remove-child content.first-child

function mount con
	content = document.get-element-by-id \content
	riot.mount content.append-child con

################
# Routing
################

page \/ index
page \/:user user

################
# Handlers
################

function index
	clean!
	mount document.create-element \mk-home

function user ctx
	clean!
	un = ctx.params.user
	user-page = document.create-element \mk-user-page
	user-page.set-attribute \user un
	mount user-page

################
# Export
################

module.exports = ~>
	page!
