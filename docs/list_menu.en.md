**Note:** _This section hasn’t been translated into English yet. The original Japanese version is below…_

# list menu

![bag](../docs/image/menu/item_list.jpg) &nbsp; ![sell](../docs/image/menu/sell_list.png)

list menuという [list](./list.md) の内容を表示しプレイヤーに選択させるための [menu](./menu.md)

スタートメニューのかばんやショップの売り物のリストなどを表示する menu のことである

## List Menu ID

list menuで表示されるlistのカテゴリはあらかじめ決まっており、それらを指定するのが List Menu ID

#### ポケモン選択リスト

PCのポケモン引き出し預け時のポケモン選択リスト

ID = PCPOKEMONLISTMENU

<img src="../docs/image/menu/pokemon_list_menu.png" width="320px" height="288px" />

#### 技選択リスト

技選択リスト

ID = MOVESLISTMENU

<img src="../docs/image/menu/move_list_menu.png" width="320px" height="288px" />

list menu の中ではこれだけ list のエントリが2byte

```asm
;　engine/battle/core.asm 
OldManItemList:
	db 1
	db POKE_BALL, 50
	db -1
```

#### 価格付きアイテムリスト

ショップで買いたいもの(売り物一覧)

ID = PRICEDITEMLISTMENU

<img src="../docs/image/menu/buy_list.png" width="320px" height="288px" />

<img src="../docs/image/menu/vending_machine.png" width="320px" height="288px" />

#### アイテムリスト

かばんの中身を表示する時にこの list menu を使う

ID = ITEMLISTMENU

<img src="../docs/image/menu/item_list.jpg" width="320px" height="288px" />

#### その他のlist menu

エレベータの階層一覧 / バッジのリスト(ハナダのバッジおじさん) などの特別な list menu

ID = SPECIALLISTMENU

<img src="../docs/image/menu/elevator.png" width="320px" height="288px" />

## memo

メニューに一度に表示できるアイテムは4つまで

カーソルが3項目めから4項目めにいくときにスクロールが生じる(よってカーソルは4項目目にいくことはない)

画面の定位置に表示される