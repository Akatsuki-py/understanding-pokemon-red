**Note:** _This section hasn’t been translated into English yet. The original Japanese version is below…_

# missable object

<img src="https://imgur.com/Hu3P0u7.png" width="240px">

直訳すると 『発見を回避できるようなオブジェクト』 

ここでは、マップ上のアイテムなどのような、条件によっては表示されないことがあるオブジェクトのことを表す

missable object に関する処理は主に `engine/overworld/missable_objects.asm` で記述されている

## wMissableObjectList

`wMissableObjectList` は WRAM のアドレス `0xd5ce` にある 17 * 2 バイトの領域で現在のマップの missable object の情報を格納する  

各missable objectのエントリごとに2バイトのデータを持つため、最大で 16個の missable objectのデータを格納できる (最後の1つは終端記号 0xff が入る)

各エントリのデータは

- スプライトのオフセット(現在のマップに依存)  
- missable object の global offset 

を表している

missable object の global offset については 下記の MapHS00 参照

## wMissableObjectFlags

`wMissableObjectFlags` は WRAM のアドレス `0xd5a6` にある32バイトの領域で、missable object の表示フラグを格納した bit列 である。

bit が 1 なら非表示であり、 32*8 = 256個の missable objectの表示を管理している

このフラグの切り替えは、 `ShowObject` と `HideObject` によって行う

## MapHS00

`MapHS00` は `data/hide_show_data.asm` で定義されているデータテーブル

`wMissableObjectList` に格納された missable object の global offset というのは MapHS00 を 0 として対象の missable object が何番目のアイテムかというのを表す値である 