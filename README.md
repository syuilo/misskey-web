![](./web.png)
-----------------------------

[![][travis-badge]][travis-link]
[![][dependencies-badge]][dependencies-link]
[![][mit-badge]][mit]

*Misskey* official client for the Web.

## External dependencies
* Node.js
* npm
* Redis (for store session date)

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
**初回起動時に表示されるウィザードに従えば自動的に設定ファイルが生成・設定されます**が、一応サンプル載せときます:
``` yaml
maintainer: Your Name <youremail@example.com>

url: "https://misskey.xyz"
port: 80

https:
  enable: true
  key: "path/of/your/tls/key"
  cert: "path/of/your/tls/cert"
  ca: "path/of/your/tls/ca"

redis:
  host: "localhost"
  port: 6379

core:
  apikey: hoge
  host: "192.168.179.2"
  port: 616
  www: "https://api.misskey.xyz"

# SEE: https://www.google.com/recaptcha/intro/index.html
recaptcha:
  siteKey: hima
  secretKey: saku

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
