**Note:** _This section hasn’t been translated into English yet. The original Japanese version is below…_

# 野生のポケモン

野生のポケモンがどのように定義されているかについての解説

## 解説

マップでどのような野生のポケモンが出現するかという情報は`data/wildPokemon/`で定義されている。

どのマップでも野生のポケモンのデータは次のようなテーブル構造になっている

```asm
MapLabel:
	db $xx          ; 地上でのエンカウント率
	db 18,DIGLETT	; [Level, PokemonID]
	...

	db $yy          ; 水上でのエンカウント率
	db 5,TENTACOOL	
	...
```

地上(草むらや洞窟など) -> 水上の順番で配置される

最初の1バイトはエンカウント率を表しており、高いほどよくポケモンとエンカウントする

具体例として、ここでは`ディグダのあな` と `21ばんどうろ` を例に解説する

```asm
; data/wildPokemon/diglettscave.asm

CaveMons:           ; マップ出現データのシンボル(初代は洞窟マップが少ないからか、CaveMons(洞窟のモンスター)というシンボルでディグダの穴を指す)
	db $14          ; ポケモンのエンカウント率
	db 18,DIGLETT   ; Lv18のディグダ
	db 19,DIGLETT   ; Lv19のディグダ
	db 17,DIGLETT   ; Lv17のディグダ
	db 20,DIGLETT   ; Lv20のディグダ
	db 16,DIGLETT   ; Lv16のディグダ
	db 15,DIGLETT   ; Lv15のディグダ
	db 21,DIGLETT   ; Lv21のディグダ
	db 22,DIGLETT   ; Lv22のディグダ
	db 29,DUGTRIO   ; Lv29のダグトリオ
	db 31,DUGTRIO   ; Lv31のダグトリオ
	db $00          ; 水上でのエンカウント率
```

```asm
; data/wildPokemon/route21.asm

Route21Mons:
	db $19
	db 21,RATTATA
	db 23,PIDGEY
	db 30,RATICATE
	db 23,RATTATA
	db 21,PIDGEY
	db 30,PIDGEOTTO
	db 32,PIDGEOTTO
	db 28,TANGELA
	db 30,TANGELA
	db 32,TANGELA
	db $05	; 水上でのエンカウント率
	db 5,TENTACOOL
	db 10,TENTACOOL
	db 15,TENTACOOL
	db 5,TENTACOOL
	db 10,TENTACOOL
	db 15,TENTACOOL
	db 20,TENTACOOL
	db 30,TENTACOOL
	db 35,TENTACOOL
	db 40,TENTACOOL
```

`CaveMons`はマップ出現データのシンボルで`WildDataPointers`で出現データを設定するときに利用される  

最初にエンカウント率があり、その後の行では`db LEVEL POKEMON`という形で出現するポケモンを設定している  

地上も水上もポケモンが出現しない場合はエンカウント率に 0を設定し、ポケモンのデータは定義しない

エンカウント率が 0より大きい場合は **かならず20バイト分(10種類分)定義する必要がある**

## LoadWildData

これらのデータはマップ切り替わり時に、 `engine/overworld/wile_mons.asm` の `LoadWildData`関数 で WRAM上にロードされる

`wGrassRate`, `wGrassMons` に地上でのエンカウント率と出現するポケモンデータ

`wWaterRate`, `wWaterMons` に水上でのエンカウント率と出現するポケモンデータ

がロードされる

## シンボルエンカウント

ミューツーのような話しかけてエンカウントする野生のポケモンについてはここでは定義されておらず、[mapObject/](../data/mapObjects/README.md)でobjectsとして定義されている

## tips

このデータをいじれば出現する野生のポケモンを好きに設定できる