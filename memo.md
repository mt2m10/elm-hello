```
### elmのインストール
### npmでインストールしてよかった気がする
$ curl -L -o elm.gz https://github.com/elm/compiler/releases/download/0.19.1/binary-for-linux-64-bit.gz
$ gunzip elm.gz
$ chmod +x elm
$ sudo mv elm /usr/local/bin/

### フォーマッターのインストール
$ npm install -g elm-format

### プロジェクト作成
$ elm init

## ホットリロード
npm install --global elm-live
```

## Elm Guide （日本語訳）

https://guide.elm-lang.jp/

## サーバ起動

http://localhost:8000 でアクセスできるようになる

```
$ elm reactor
```

## ホットリロードで確認する

http://localhost:8000 でアクセスできるようになる

```
$elm-live src/Main.elm --start-page=index.html -- --output=elm.js
```

## todo

Todoアプリケーションの基本的なインターフェースに必要な項目は以下の通りです。

1. Todoリストの表示領域：Todoの一覧を表示する領域が必要です。これには、タスクのタイトル、完了フラグ（完了した場合はチェックマークなど）、編集/削除ボタンなどが含まれます。
1. Todoを追加するフォーム：新しいTodoを追加するためのフォームが必要です。これには、タスクのタイトルを入力するテキストボックスと、追加ボタンが含まれます。
1. タスクの編集フォーム：タスクを編集するためのフォームが必要です。これには、タスクのタイトルを編集するためのテキストボックスと、変更を保存するためのボタンが含まれます。
1. フィルタリング機能：完了済みのタスクや未完了のタスクのみを表示するために、フィルタリング機能が必要です。一般的には、完了/未完了の切り替えボタンや、完了済みタスクを非表示にするボタンなどが含まれます。
1. ソート機能：タスクを優先度や期限、追加日時などの基準でソートする機能があると、タスクの管理がしやすくなります。
1. タスクの状態の保存機能：作成したタスクや編集したタスクの情報を保存し、再度アプリにアクセスした際にも表示されるようにする機能が必要です。通常、ブラウザのローカルストレージを使用して保存します。

これらの要素を組み合わせることで、使いやすく機能的なTodoアプリケーションを実装することができます。

## css

Bootstrap

https://bootstrap-guide.com/

## todo 参考

https://todomvc.com/examples/elm/