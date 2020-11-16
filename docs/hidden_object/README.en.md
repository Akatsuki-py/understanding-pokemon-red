**Note:** _This section hasn’t been translated into English yet. The original Japanese version is below…_

# hidden object

hidden objectは、スプライトではないがAボタンを押すと何かしらのアクションがあるオブジェクトのことを指す

以下 HiddenObjects と呼ぶ

## HiddenObjects の例

- ゲーム内の見えないアイテム
- ジムの石像
- PC
- ゴミ箱
- スロットマシン
- 本棚(後述)
- タウンマップ(後述)
- フレンドリーショップの陳列棚(後述)

## Format

基本的な HiddenObjects のデータは `data/hidden_objects.asm` で記述されている

各マップごとに次のテーブルの形で記述される

```asm
; 例1: ニビシティジム
PewterGymHiddenObjects: 
	db $0a,$03,$04						; YCoord, XCoord, TextID
	dbw BANK(GymStatues),GymStatues		; object routine

	db $0a,$06,$04
	dbw BANK(GymStatues),GymStatues
	
	db $FF	; 終端記号

; 例2: トキワの森
ViridianForestHiddenObjects:
	db $12,$01,POTION					; YCoord, XCoord, ItemID
	dbw BANK(HiddenItems),HiddenItems	; object routine
	db $2a,$10,ANTIDOTE
	dbw BANK(HiddenItems),HiddenItems
	db $FF
```

## object routine

HiddenObjects に対してAボタンを押した時に実行される処理のこと

以下、 ObjectRoutine と呼ぶ

ゲーム内の見えないアイテムの場合は `HiddenItems` が ObjectRoutineとなり、HiddenObjectsの各エントリの3バイト目は TextIDではなく、アイテムのItemIDとして扱われる

## 本棚、タウンマップ、陳列棚

[本棚](bookshelf.md)参照
