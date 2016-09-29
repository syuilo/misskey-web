document.domain = CONFIG.host

# ↓ iOS待ちPolyfill (SEE: http://caniuse.com/#feat=fetch)
require 'fetch'

# ↓ Firefox, Edge待ちPolyfill
if NodeList.prototype.forEach === undefined
	NodeList.prototype.forEach = Array.prototype.forEach

window.api = require './common/scripts/api.ls'
window.is-promise = require './common/scripts/is-promise.ls'

riot = require 'riot'
require './common/tags/core-error.tag'
require './common/tags/url.tag'
require './common/tags/url-preview.tag'
require './common/tags/ripple-string.tag'
require './common/tags/kawaii.tag'

riot.mixin \cache do
	cache: require './common/scripts/cache.ls'

riot.mixin \get-post-summary do
	get-post-summary: require './common/scripts/get-post-summary.ls'

riot.mixin \text do
	analyze: require 'misskey-text'
	compile: require './common/scripts/text-compiler.js'

riot.mixin \get-password-strength do
	get-password-strength: require 'strength.js'

riot.mixin \ui-progress do
	Progress: require './common/scripts/loading.ls'

window._I = ((document.cookie.match /i=([a-zA-Z0-9]+)/) || [null, null]).1
window.SIGNIN = window._I?

module.exports = require './boot.ls'
