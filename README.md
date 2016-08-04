![](./web.png)
-----------------------------

[![][travis-badge]][travis-link]
[![][dependencies-badge]][dependencies-link]
[![][mit-badge]][mit]

*Misskey* official client for the Web.

## External dependencies
* Node.js
* npm
* Redis
* GraphicsMagick (for trimming, compress, etc etc)

## How to build
1. `git clone git://github.com/syuilo/misskey-web.git`
2. `cd misskey-web`
3. `npm install`
4. `npm run dtsm`
4. `./node_modules/.bin/bower install --allow-root`
5. `npm run build`

## How to launch
`npm start`

## Show options
`npm start -- -h`

## Configuration

``` yaml
# サーバーの管理者情報
maintainer: Your Name <youremail@example.com>

# URL
url: <string>

# 待ち受けポート
port: <number>

# TLS設定
https:
  enable: <boolean>
  key: <string>
  cert: <string>
  ca: <string>

# Redis
redis:
  host: <string>
  port: <number>

# Coreサーバー情報
core:
  apikey: <string>
  host: <string>
  port: <string>
  url: <string>

# reCAPTCHA設定
# SEE: https://www.google.com/recaptcha/intro/index.html
recaptcha:
  siteKey: <string>
  secretKey: <string>

```

## People

The original author of Misskey is [syuilo](https://github.com/syuilo)

The current lead maintainer is [syuilo](https://github.com/syuilo)

[List of all contributors](https://github.com/syuilo/misskey-web/graphs/contributors)

## License
[MIT](LICENSE)

[mit]:                http://opensource.org/licenses/MIT
[mit-badge]:          https://img.shields.io/badge/license-MIT-444444.svg?style=flat-square
[travis-link]:        https://travis-ci.org/syuilo/misskey-web
[travis-badge]:       http://img.shields.io/travis/syuilo/misskey-web.svg?style=flat-square
[dependencies-link]:  https://gemnasium.com/syuilo/misskey-web
[dependencies-badge]: https://img.shields.io/gemnasium/syuilo/misskey-web.svg?style=flat-square
