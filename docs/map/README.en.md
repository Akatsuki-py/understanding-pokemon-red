**Note:** _This section hasn’t been translated into English yet. The original Japanese version is below…_

# Map

マップについて

## Map Header

Map Header はタイルセットの情報やテキストデータのテーブルなど、マップを構成する様々な情報を持っている

詳しくは[Map Header](./map_header.md)参照

## タイルデータ

マップがどのようなタイルデータで構成されているかはblkフォーマットで表されている

詳しくは[blk](./blk.md)を参照

## Map Object

マップにオブジェクト(人や看板やワープ)がどのように配置されているかを定義している

詳細は [Map Object](./map_object.md)を参照

## Map Script

マップに紐づけられた処理

詳細は [Map Script](./map_script.md)を参照

## 単位

このレポジトリで使われる様々な単位

種類が多くて混乱を招くのでここに一覧をかく

 単位名  |  日本語  |  x  |  y  |  x*y  | 説明 
---- | ---- | ---- | ----  | ----  | ----
tile | タイル | 8 | 8 | 8*8  | 最小単位
grid | グリッド | 16 | 16 | 16*16  | null
tile block | タイルブロック | 16 | 16 | 16*16 | 2x2 tile blocksと表されたとき
tile block | タイルブロック | 32 | 32 | 32*32 | 4x4 tile blocksと表されたとき
