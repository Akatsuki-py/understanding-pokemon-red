**Note:** _This section hasn’t been translated into English yet. The original Japanese version is below…_

# キー入力

ポケモン赤でのキー入力処理は `home/joypad.asm` と `engine/joypad.asm` で定義されている

- GameBoyからキー入力を読み取る処理
- キー入力を使いやすい形に加工する処理

の2つの部分からなる

## キー入力の利用

キー入力の情報を利用するときには加工された変数を参照するがこの変数は3種類ある

各変数は1バイトでそれぞれのビットの配置が、[↓, ↑, ←, →, Start, Select, B, A] に対応している

またGameBoyのJoyPadレジスタと違って有効になっている状態でビットが立つことに注意

- `hJoyReleased` 押した状態が解除されたキー入力を格納
- `hJoyPressed` 押した状態になったキー入力を格納
- `hJoyHeld` 押されている状態のキー入力を格納

## キー入力の読み取り

キー入力の読み取りは各フレームのVBlankのときに行われる

ここでの読み取り結果は`hJoyInput`に格納される

## キー入力の加工

キー入力の結果が必要な時に呼び出され、上記の3種類の変数に加工されたキー入力の状態が格納される

## 関連

- [simulated joypad](./simulated_joypad.md)
