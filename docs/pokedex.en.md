**Note:** _This section hasn’t been translated into English yet. The original Japanese version is below…_

# ポケモン図鑑

## 図鑑の状態

- wPokedexOwned
- wPokedexSeen

## 図鑑の評価

`engine/pokedex_rating.asm`で図鑑を評価する処理が記述されている

`DexRatingsTable` というテーブルでは、ポケモンの数とテキストのアドレスが各エントリに配置されている

図鑑評価時には、プレイヤーのつかまえたポケモンの数が該当するテーブルエントリをループにより探索し、該当のテーブルエントリのテキストを評価として表示する

```asm
DexRatingsTable:
	db 10						; ポケモン数
	dw PokedexRatingText_44201	; 0 < 図鑑の捕まえた数 < 10 のときのオーキド博士からの評価テキスト
	db 20
	dw PokedexRatingText_44206  ; 10 <= 図鑑の捕まえた数 < 20 のときのオーキド博士からの評価テキスト
    ...
    db 150
	dw PokedexRatingText_44247
	db NUM_POKEMON + 1
	dw PokedexRatingText_4424c  ; 150 <= 図鑑の捕まえた数 < 152 のときのオーキド博士からの評価テキスト
```

### ミュウ

ミュウは通常プレイでは手に入らないポケモンというのが理由なのか、図鑑評価のテキストは150匹と151匹で同じ評価になる

### 図鑑が152以上のとき

Youtubeの [ポケモン 152匹以上の図鑑をオーキド博士に見せると…](https://www.youtube.com/watch?v=M4MC18wHK2E) では152匹のポケモンを捕まえた状態でオーキド博士に図鑑評価してもらおうとするとフリーズする

これは`DexRatingsTable`の『つかまえたポケモン』の数によるテーブルエントリが151匹までしか用意されていないのと、終端記号によるテーブル探索の終了がおきないのが原因である。

『つかまえたポケモン』の数によるテーブル探索のループが`DexRatingsTable`を突き抜けていって不正なアドレスを参照してしまい、テキスト表示時に問題を起こしてフリーズしていると思われる

