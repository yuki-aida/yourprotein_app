# YourProtein App

Rails Tutorialを学んだ後、知識を定着させる目的で作ったアプリです。
このアプリでは、トレーニングに用いるプロテインやウェアやアイテムなどを
自由に共有することができます。

機能一覧

・ユーザー登録機能
・アカウントの認証機能
・ログイン、ログアウト機能
・記事、画像の投稿機能
・記事一覧表示機能
・ページネーション機能
・フォロー機能
・お気に入り機能
・検索機能

インフラ構成

・統合開発環境
　・AWS(Cloud9)
・公開用プラットフォーム
　・Heroku
・バージョン管理
　・Git
・Webサーバー
　・Production環境
　　・Puma 3.9.1
・DB
　・Production環境
　　・PostgreSQL(0.20.0)
・フロントエンド言語
　・HTML
　・SCSS
　・Javascript
・バックエンド言語
　・Ruby 2.6.3
　・Ruby on Rails 5.1.6