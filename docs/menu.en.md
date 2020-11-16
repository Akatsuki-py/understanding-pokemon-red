**Note:** _This section hasn’t been translated into English yet. The original Japanese version is below…_

# menu

ポケモン赤でのmenuは、

- マップ上でスタートボタンを押すと現れるウィンドウ
- はい、いいえの2択ウィンドウ
- その他の様々な選択肢を表示するウィンドウ

といったようにプレイヤーに選択を要求するウィンドウのことを表している

## 例  

<img src="../docs/image/menu/menu.jpg" width="320px" height="288px" alt="start"> &nbsp; <img src="../docs/image/menu/fossil.png" width="320px" height="288px" alt="fossil">

<img src="https://imgur.com/rJQSNz1.png" width="320px" height="288px" alt="yesno"> &nbsp; <img src="https://imgur.com/wRa62p9.png" width="320px" height="288px" alt="heal">

## ID

menu のどの項目を選択しているかを識別するために項目に割り振られた値

上から順に 0, 1, 2, 3, ...と割り振られていく(一番上のアイテムというのは現在画面で見えている一番上のアイテムのことを指すことに注意)

## HandleMenuInput

プレイヤーのキー入力の結果をハンドルする処理

ループ処理を行いプレイヤーの入力に対応する

A/Bボタンが入力された場合は、選択時のSEを鳴らしてループを抜け終了

↑↓ボタンが押された時は、 `wCurrentMenuItem` を変更してカーソル位置を変更しループに戻る

また一定時間立った時は、強制的にループを抜ける(この処理がCPUを占有してはいけないので)

## wrapping

選択menuで一番下の選択肢にあるときに下を押したときに一番上に戻る、または一番上のmenuにあるときに上を押したときに一番下にいく状態のこと

上述の `HandleMenuInput` は wrapping に対応していない、つまり `wCurrentMenuItem` が 0 のときに↑を押しても 0のままなので、wrappingが必要な場合は、`HandleMenuInput`の外で行う必要がある

## list menu

[list menu](./list_menu.md) 参照
