**Note:** _This section hasn’t been translated into English yet. The original Japanese version is below…_

# テキスト

## 文字コードについて

[文字コード](charcode.md)を参照

## テキストデータに関連するマクロ

[テキストデータに関連するマクロ](./macro.md)参照

## テキストデータの解釈

 例えば次のテキストデータは次のように解釈できる

```asm
_PalletTownText5::
	text "PALLET TOWN"	
	line "Shades of your"
	cont "journey await!"
	done
```

1. テキストボックスが開いて『PALLET TOWN』を1行目に配置
2. テキストボックスの2行目に『Shades of your』を配置
3. テキストボックスの3行目(Aボタンを押すとテキストボックスが下にスクロール)に『journey await!』を配置
4. テキスト終了

## テキストの描画

[テキストの描画](./text_render.md)参照

## テキストコマンド

テキストデータは、画面に描画する用途以外にも独自の内部コマンドとして使われる用途も持っている。

`TextCommandProcessor`でbcレジスタの示すアドレスにある文字列をさながらスクリプトのように解釈する。

このテキストコマンドによってプロンプト(▼)の点滅や、テキストボックスのスクロールなどの処理を呼び出せたりする。
