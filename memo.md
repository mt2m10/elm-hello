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
```

## Elm Guide （日本語訳）

https://guide.elm-lang.jp/

## サーバ起動

http://localhost:8000 でアクセスできるようになる

```
$ elm reactor
```