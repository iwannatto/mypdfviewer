# アプリケーション概要
このアプリケーションは、
* pdfファイルをアップロードするとjpeg化する
* それらのpdfを最終閲覧順に一覧できる

というアプリケーションです。  
個人的にrailsを練習するために作ったものです。  
実装の概要としては、
* scaffoldingで骨組み
* active storageでファイル管理(n+1も対処)
* サーバにimagemagickを入れ、minimagickを通じて呼び出しpdf→jpeg変換
* pdfの拡張子チェックのコントローラレベルバリデーション  
  (active storageなのでモデルではなくコントローラにした)
* 最終閲覧の即時反映のため、turbolinksの部分的無効化

といった感じです。
詳しい開発日記については、  
[http://iwannatto.hatenablog.com/entry/2018/08/24/230112](http://iwannatto.hatenablog.com/entry/2018/08/24/230112)  
もご覧ください。

また、herokuにもあるので、使用感を試すことができます。  
[https://mypdfviewer.herokuapp.com/pdfs](https://mypdfviewer.herokuapp.com/pdfs)  
ただし、アップロードされたファイルは公開される上に勝手に消滅するので、  
その点にはご留意ください。

# 環境について

このアプリをサーバにて動作させる場合、imagemagickが必要です。
```
$ convert --version
Version: ImageMagick 6.7.8-9 2016-06-22 Q16 http://www.imagemagick.org
Copyright: Copyright (C) 1999-2012 ImageMagick Studio LLC
Features: OpenMP
```

```
$ rails about
About your application's environment
Rails version             5.2.0
Ruby version              2.4.1-p111 (x86_64-linux)
RubyGems version          2.6.14
Rack version              2.0.5
JavaScript Runtime        Node.js (V8)
...
Database adapter          sqlite3
```