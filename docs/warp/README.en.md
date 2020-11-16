**Note:** _This section hasn’t been translated into English yet. The original Japanese version is below…_

# warp

建物の出入り、町<->道路の出入りなど連続でない移動のことをwarpという

マップのwarpの情報は ROMの Map Header (正確には Map Headerの指す Map Object) に次のようなデータ構造で格納されている  

```asm
; 主人公の家の1階
RedsHouse1F_Object:
    ... ; 省略

    ; warps
	db 3                        ; ワープは3つ
	warp 2, 7, 0, -1            ; 家の出口1
	warp 3, 7, 0, -1            ; 家の出口2(カーペットなので2マス出口がある)
	warp 7, 1, 0, REDS_HOUSE_2F ; 上に上がる階段

    ... ; 省略
```

`warp`マクロについては Map Objectの [warps](../map/map_object.md#warps)参照

## LoadMapHeader

マップのwarpの情報は マップ読み込み時に `LoadMapHeader` によって ROMの Map Header から WRAMにロードされる

`wNumberOfWarps` に warpのマップ上の個数が、 `wWarpEntries` に warpのデータが Map Header からコピーされる

## Special Warp

[Special Warp](./special_warp.md)参照
