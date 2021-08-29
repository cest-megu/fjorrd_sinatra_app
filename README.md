# このアプリについて
  - フィヨルドブートキャンプというプログラミングスクールで作成したSinatraのメモアプリです。
  - 簡単なメモの新規投稿、一覧表示、編集、削除ができます。
# アプリ立ち上げ方法
## git clone
作業したいローカルフォルダに移動します。
`git clone https://github.com/cest-megu/fjorrd_sinatra_app.git`
を実行します。

## gemファイルのインストール
- `fjord_sinatra_app`のディレクトリに移動します。
- アプリ立ち上げのため、必要なgemファイルをインストールするために、
```
bundle install
```
を実行します。

## アプリ、ブラウザの立ち上げ
- ターミナルで

```
ruby main.rb
```
を実行します。

- ブラウザを開いて、`localhost:4567/memos`にアクセスできればメモアプリが使用できます。
