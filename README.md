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

# 開発環境
* macOS High Sierra 10.13.6
* ruby 2.4.1 
* SQLite 3.19.3
* NodeがないのでJS runtimeはJavaScriptCoreとかいうやつになってる（？）

# デプロイ
herokuにデプロイするのを想定しています  

imagemagickが必要です  
```
$ convert --version
Version: ImageMagick 7.0.8-59 Q16 x86_64 2019-08-05 https://imagemagick.org
Copyright: © 1999-2019 ImageMagick Studio LLC
License: https://imagemagick.org/script/license.php
Features: Cipher DPC HDRI Modules OpenMP(3.1) 
Delegates (built-in): bzlib freetype heic jng jp2 jpeg lcms ltdl lzma openexr png tiff webp xml zlib
```

# memo
