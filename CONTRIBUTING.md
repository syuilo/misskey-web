THANKS FOR CONTRIBUTING
-----------------------

Issue reports and pull requests are always welcome!

## Code Style

- Use Tab for indentation
- Limit lines to 100 columns


### Return Early

-   BAD

``` sourceCode
function foo() {
  if (x) {
    ...
  }
}
```

-   GOOD

``` sourceCode
function foo() {
  if (!x) {
    return;
  }

  ...
}
```

Keeps indentation levels down and makes more readable.


## tagについて
Riotのtagは、Jade+Stylus+LiveScriptで書きます(すべてインデントでブロックを表すタイプの言語(！))。
**それに加え、Misskey独自の拡張/改良を加えています:**
* タグファイル内のscriptおよびstyleのインデントは不要です(本来ならばtagの子にしなければならないために、**無意味に**一段ネストが深くなってしまう(tagの子でなくとも、同じファイルに記述されている以上、そのstyleとscriptはそのtagのものであるということが**明らか**))。
* タグファイル内のscriptおよびstyleにtypeやscopedの指定は不要です。styleは、デフォルトで*scoped*です(*scoped*以外のstyleをタグファイルに記述したい場合なんてあるか？？？？？？)。
* styleは暗黙的に:scopeがルートに存在しているとみなします(scope以外にスタイルを当てたい場合なんてあるか？？？？？？？？？？？？？？？？？？？？？？？？)。
* テンプレート変数を記述する際に、本来ならばJade特有の記法と競合してしまうために`hoge='{piyo}'`と書かなければいけませんが、`hoge={piyo}`と書けるようにしています(その代償としてJadeのstyle記法は使えなくなりました(まあそんなに使うことないと思うので))。
* `div(name='hoge')`は、`div@hoge`と書けます。Riot.jsの特性上、nameを指定することが多いので、このように短く書けるようにしました。また、script(LiveScript)上において、name指定した要素を@hogeのようにしてアクセスするので(LiveScriptでは、`this.`を`@`と書けます)、表現が一致して分かりやすくなります。
* スタイルには暗黙的に`$theme-color`と`$theme-color-foreground`変数が宣言されます。
* Jadeには暗黙的に`config`変数が設定されます。これには設定ファイルの内容が含まれます。

まとめると、以下のコード
```jade
todo
	h3 TODO

	ul
		li(each='{ item, i in items }')= '{ item }'

	form(onsubmit='{ handleSubmit }')
		input
		button
			| Add { items.length + 1 }

	script.
		@items = []

		@handle-submit = (e) ~>
			input = e.target.0
			@items.push input.value
			input.value = ''

	style(type='stylus', scoped).
		:scope
			$theme-color = #ec6b43

			background #fff

			> h3
				font-size 1.2em
				color $theme-color
```

は、以下のように書けるということです:

```jade
todo
	h3 TODO

	ul
		li(each={ item, i in items })= { item }

	form(onsubmit={ handleSubmit })
		input
		button
			| Add { items.length + 1 }

script.
	@items = []

	@handle-submit = (e) ~>
		input = e.target.0
		@items.push input.value
		input.value = ''

style.
	background #fff

	> h3
		font-size 1.2em
		color $theme-color
```

styleに至っては二段も**余計な**インデントを無くすことができました。

## 設計思想
タグは、他のタグのDOM構造がどのようになっているかは知る必要がなく、自分自身のDOM構造だけ知っていれば良いようにします。
たとえばタイムライン タグがあり、その中に投稿タグが配列されている場合を考えます。このとき、タイムライン タグが、ユーザーのキーボード入力を監視して「t」キーが押されたときに、タイムラインの最新の投稿タグにフォーカスを合わせたいとします。
ここで、タイムライン タグは投稿タグのDOMを知らないので、フォーカスを合わせるにはどうしたら良いのでしょうか。
良い解決策は、タグ間で、イベントのやり取りを行うことです。投稿タグは「キミにフォーカスを当てたい」というイベントが来るか監視し、イベントがきたときに自分自身のDOMにフォーカスを当てるコードを書けばいいのです。タイムライン タグは、「t」キーが押下されたときに、投稿タグに対して、先の「フォーカスを当ててくれ」イベントを発信するだけでいいのです。
これで、タイムライン タグは、投稿タグの内部のDOM的な実装を知ることなしに、フォーカスを合わせることができます。

気づいた方もいるかもしれませんが、**これはオブジェクト指向ではないでしょうか？**
タグの内部実装を知る必要がないのはカプセル化に値し、イベントの送受信はクラスのインスタンスに対するメソッド呼び出しのようなものです。
だから、Misskeyのクライアントサイド設計は、オブジェクト指向的であると言って良いと思います。
