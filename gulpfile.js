//////////////////////////////////////////////////
// MISSKEY-WEB BUILDER
//////////////////////////////////////////////////

'use strict';

Error.stackTraceLimit = Infinity;

const fs = require('fs');
const gulp = require('gulp');
const gutil = require('gulp-util');
const glob = require('glob');
const del = require('del');
const babel = require('gulp-babel');
const ts = require('gulp-typescript');
const tslint = require('gulp-tslint');
const browserify = require('browserify');
const source = require('vinyl-source-stream');
const buffer = require('vinyl-buffer');
const es = require('event-stream');
const replace = require('gulp-replace');
const stylus = require('gulp-stylus');
const cssnano = require('gulp-cssnano');
const autoprefixer = require('gulp-autoprefixer');
const uglify = require('gulp-uglify');
const ls = require('browserify-livescript');
const aliasify = require('aliasify');
const riotify = require('riotify');
const transformify = require('syuilo-transformify');
require('typescript-require')(require('./tsconfig.json'));

const env = process.env.NODE_ENV;
const isProduction = env === 'production';

/*
 * Browserifyのモジュールエイリアス
 */
const aliasifyConfig = {
	"aliases": {
		"fetch": "./bower_components/fetch/fetch.js",
		"velocity": "./bower_components/velocity/velocity.js",
		"ripple.js": "./bower_components/ripple.js/ripple.js",
		"strength.js": "./bower_components/password-strength.js/strength.js",
		"js-cookie": "./bower_components/js-cookie/src/js.cookie.js",
		"cropper": "./bower_components/cropper/dist/cropper.js",
		"moment": "./bower_components/moment/moment.js",
		"Sortable": "./bower_components/Sortable/Sortable.js",
		"fastclick": "./bower_components/fastclick/lib/fastclick.js",
		"fuck-adblock": "./bower_components/fuck-adblock/fuckadblock.js",
		"Swiper": "./bower_components/Swiper/dist/js/swiper.js"
	},
	appliesTo: {
		"includeExtensions": ['.js', '.ls']
	}
};

const project = ts.createProject('tsconfig.json', {
	typescript: require('typescript')
});

//////////////////////////////////////////////////
// Full build
gulp.task('build', [
	'build-before',
	'test',
	'build:ts',
	'copy:bower_components',
	'build:scripts',
	'build:styles',
	'build-copy'
], () => {
	gutil.log('ビルドが終了しました。');

	if (!isProduction) {
		gutil.log('■　注意！　開発モードでのビルドです。');
	}
});

gulp.task('clean-build', [
	'clean',
	'build'
]);

//////////////////////////////////////////////////
// LOG INFO
gulp.task('build-before', () => {
	gutil.log('Misskey-Webのビルドを開始します。時間がかかる場合があります。');
	gutil.log('ENV: ' + env);
});

//////////////////////////////////////////////////
// TypeScriptのビルド
gulp.task('build:ts', () => {
	gutil.log('TypeScriptをコンパイルします...');

	return project
		.src()
		.pipe(ts(project))
		.pipe(babel({
			presets: ['es2015', 'stage-3']
		}))
		.pipe(gulp.dest('./built/'));
});

//////////////////////////////////////////////////
// Bowerのパッケージのコピー
gulp.task('copy:bower_components', () => {
	gutil.log('Bower経由のパッケージを配置します...');

	return gulp.src('./bower_components/**/*')
		.pipe(gulp.dest('./built/resources/bower_components/'));
});

//////////////////////////////////////////////////
// フロントサイドのスクリプトのビルド
gulp.task('build:scripts', done => {
	gutil.log('フロントサイドスクリプトを構築します...');

	const config = require('./src/config.ts').default;

	glob('./src/web/**/*.ls', (err, files) => {
		const tasks = files.map(entry => {
			let bundle =
				browserify({
					entries: [entry]
				})
				.transform(ls)
				.transform(aliasify, aliasifyConfig)
				// tagの{}の''を不要にする (その代わりスタイルの記法は使えなくなるけど)
				.transform(transformify((source, file) => {
					if (file.substr(-4) !== '.tag') return source;
					let dist = '';
					const lines = source.split('\r\n');
					let flag = false;
					lines.forEach(line => {
						if (line === 'style.' || line === 'script.') {
							flag = true;
						}
						if (!flag) {
							if (line.replace(/\t/g, '')[0] === '|') {
								through();
							} else {
								dist += line.replace(/([+=])\s?\{(.+?)\}/g, '$1"{$2}"') + '\r\n';
							}
						} else {
							through();
						}

						function through() {
							dist += line + '\r\n';
						}
					});
					return dist;
				}))
				// tagの@hogeをname='hoge'にする
				.transform(transformify((source, file) => {
					if (file.substr(-4) !== '.tag') return source;
					let dist = '';
					const lines = source.split('\r\n');
					let flag = false;
					lines.forEach(line => {
						if (line === 'style.' || line === 'script.') {
							flag = true;
						}
						if (!flag) {
							if (line.indexOf('@') === -1) {
								through();
							} else if (line.replace(/\t/g, '')[0] === '|') {
								through();
							} else {
								while (line.match(/@[a-z-]+/) !== null) {
									const match = line.match(/@[a-z-]+/);
									let name = match[0];
									if (line[line.indexOf(name) + name.length] === '(') {
										line = line.replace(name + '(', '(name=\'' + name.substr(1) + '\',');
									} else {
										line = line.replace(name, '(name=\'' + name.substr(1) + '\')');
									}
								}
								dist += line + '\r\n';
							}
						} else {
							through();
						}

						function through() {
							dist += line + '\r\n';
						}
					});
					return dist;
				}))
				// tagのchain-caseをcamelCaseにする
				.transform(transformify((source, file) => {
					if (file.substr(-4) !== '.tag') return source;
					let dist = '';
					const lines = source.split('\r\n');
					let flag = false;
					lines.forEach(line => {
						if (line === 'style.' || line === 'script.') {
							flag = true;
						}
						if (!flag) {
							(line.match(/\{\s?([a-z-]+)\s?\}/g) || []).forEach(x => {
								line = line.replace(x, camelCase(x));
							});
							dist += line + '\r\n';
						} else {
							through();
						}

						function through() {
							dist += line + '\r\n';
						}
					});
					return dist;

					function camelCase(str) {
						str = str.charAt(0).toLowerCase() + str.slice(1);
						return str.replace(/[-_](.)/g, (match, group1) => {
							return group1.toUpperCase();
						});
					}
				}))
				// tagのstyleの定数
				.transform(transformify((source, file) => {
					if (file.substr(-4) !== '.tag') return source;
					let dist = '';
					const lines = source.split('\r\n');
					lines.forEach(line => {
						if (line === 'style.') {
							through();
							dist += '\t$theme-color = ' + config.themeColor + '\r\n';
							dist += '\t$theme-color-foreground = ' + config.themeColorForeground + '\r\n';
						} else {
							through();
						}

						function through() {
							dist += line + '\r\n';
						}
					});
					return dist;
				}))
				// tagのstyleを暗黙的に:scopeにする
				.transform(transformify((source, file) => {
					if (file.substr(-4) !== '.tag') return source;
					let dist = '';
					const lines = source.split('\r\n');
					let flag = false;
					lines.forEach(line => {
						let next = false;
						if (line === 'script.') {
							flag = false;
						} else if (line === 'style.') {
							through();
							dist += '\t:scope\r\n';
							flag = true;
							next = true;
						}

						if (!next) {
							if (flag) {
								dist += '\t\t' + line + '\r\n';
							} else {
								through();
							}
						}

						function through() {
							dist += line + '\r\n';
						}
					});
					return dist;
				}))
				// tagのstyleおよびscriptのインデントを不要にする
				.transform(transformify((source, file) => {
					if (file.substr(-4) !== '.tag') return source;
					let dist = '';
					const lines = source.split('\r\n');
					let flag = false;
					lines.forEach(line => {
						if (line === 'style.' || line === 'script.') {
							flag = true;
						}
						if (flag) {
							dist += '\t' + line + '\r\n';
						} else {
							through();
						}

						function through() {
							dist += line + '\r\n';
						}
					});
					return dist;
				}))
				.transform(transformify((source, file) => {
					if (file.substr(-4) !== '.tag') return source;
					let dist = '';
					const lines = source.split('\r\n');
					let flag = false;
					lines.forEach(line => {
						if (line === '\tstyle.') {
							dist += line = '\tstyle(type=\'stylus\', scoped).\r\n';
						} else {
							dist += line + '\r\n';
						}
					});
					return dist;
				}))
				// スペースでインデントされてないとエラーが出る
				.transform(transformify((source, file) => {
					if (file.substr(-4) !== '.tag') return source;
					return source.replace(/\t/g, '  ');
				}))
				.transform(riotify, {
					template: 'pug',
					type: 'livescript',
					//expr: true,
					compact: true,
					parserOptions: {
						template: {
							config: config
						}
					}
				})
				/*
				// LiveScruptがHTMLクラスのショートカットを変な風に生成するのでそれを修正
				.transform(transformify((source, file) => {
					if (file.substr(-4) !== '.tag') return source;
					return source.replace(/class="\{\(\{(.+?)\}\)\}"/g, 'class="{$1}"');
				}))*/
				.bundle()
				.pipe(source(entry.replace('src/web', 'resources').replace('.ls', '.js')))
				.pipe(replace(/CONFIG\.themeColor/g, '"' + config.themeColor + '"'))
				.pipe(replace(/CONFIG\.api\.url/g, '"' + config.api.url + '"'))
				.pipe(replace(/CONFIG\.urls\.signin/g, '"' + config.urls.signin + '"'))
				.pipe(replace(/CONFIG\.url/g, '"' + config.url + '"'));

			if (isProduction) {
				bundle = bundle
					.pipe(buffer())
					.pipe(uglify());
			}

			return bundle
				.pipe(gulp.dest('./built'));
		});

		es.merge(tasks).on('end', done);
	});
});

//////////////////////////////////////////////////
// フロントサイドのスタイルのビルド
gulp.task('build:styles', ['copy:bower_components'], () => {
	gutil.log('フロントサイドスタイルを構築します...');

	return gulp.src('./src/web/**/*.styl')
		.pipe(replace(/url\("#/g, 'url\("' + config.urls.resources))
		.pipe(stylus())
		.pipe(autoprefixer({
			// ☆IEは9以上、Androidは4以上、iOS Safariは8以上
			// その他は最新2バージョンで必要なベンダープレフィックスを付与する設定
			browsers: ['last 2 versions', 'ie >= 9', 'Android >= 4', 'ios_saf >= 8'],
			cascade: false
		}))
		.pipe(isProduction
			? cssnano({
				safe: true // 高度な圧縮は無効にする (一部デザインが不適切になる場合があるため)
			})
			: gutil.noop())
		.pipe(gulp.dest('./built/resources/'));
});

//////////////////////////////////////////////////
// その他のリソースのコピー
gulp.task('build-copy', [
	'build:ts',
	'build:scripts',
	'build:styles'
], () => {
	gutil.log('必要なリソースをコピーします...');

	return es.merge(
		gulp.src('./src/web/**/*.pug').pipe(gulp.dest('./built/web/')),
		gulp.src('./src/resources/**/*').pipe(gulp.dest('./built/resources/')),
		gulp.src('./src/web/desktop/resources/**/*').pipe(gulp.dest('./built/resources/desktop/')),
		gulp.src('./src/web/mobile/resources/**/*').pipe(gulp.dest('./built/resources/mobile/')),
		gulp.src('./src/resources/favicon.ico').pipe(gulp.dest('./built/resources/')),
		gulp.src([
			'./src/web/**/*',
			'!./src/web/**/*.styl',
			'!./src/web/**/*.js',
			'!./src/web/**/*.ts',
			'!./src/web/**/*.ls'
		]).pipe(gulp.dest('./built/resources/'))
	);
});

//////////////////////////////////////////////////
// テスト
gulp.task('test', [
	'lint'
]);

//////////////////////////////////////////////////
// Lint
gulp.task('lint', () => {
	gutil.log('構文の正当性を確認します...');

	return gulp.src('./src/**/*.ts')
		.pipe(tslint({
			formatter: "verbose"
		}))
		.pipe(tslint.report())
});

//////////////////////////////////////////////////
// CLEAN
gulp.task('clean', cb => {
	del([
		'./built',
		'./tmp'
	], cb);
});

gulp.task('clean-all', ['clean'], cb => {
	del([
		'./node_modules',
		'./bower_components',
		'./typings'
	], cb);
});
