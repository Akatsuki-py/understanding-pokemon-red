**Note:** _This section hasn’t been translated into English yet. The original Japanese version is below…_

# predef

事前に関数を特定の領域に登録しておくことで、現在のバンクやレジスタの状態にかかわらず登録しておいた関数を呼び出せるようにしたもの

## 解説

predefでは事前定義という言葉が示すようにpredefテーブルに関数を事前に登録しておく

事前に登録しておいた関数はpredefマクロを用いて呼び出すことができる

## callによる関数呼び出しとの違い

callはすでにROMバンクに存在している関数にしかジャンプできず、呼び出すときもPCしかスタックに保存しない

predefによる関数呼び出しは対象の関数が現在セットされていなくても可能(far callが可能)であり、呼び出す際にhl, de, bcをスタックに退避する

**以後、predefで呼び出される関数のことをpredef-routineと呼ぶ**

## predefテーブルへの登録

[predefs.asm](../engine/predefs.asm)で行われている

`add_predef`マクロでpredef-routineのあるバンク番号とアドレスをテーブル(`PredefPointers`)に登録する

```asm
PredefPointers::
	add_predef DrawPlayerHUDAndHPBar
	add_predef CopyUncompressedPicToTilemap
	add_predef AnimateSendingOutMon
    ...
```

## predef-routineの呼び出し

[asm_macros.asm](../macros/asm_macros.asm)で定義されている`predef`マクロを用いる

```asm
predef [predef_routine_name]
```

のようにしてpredef-routineを実行することができる

## 参考

 - [predef.asm](../home/predef.asm)
 - [predefs.asm](../engine/predefs.asm)
 - [asm_macros.asm](../macros/asm_macros.asm)
 - [discord](https://discordapp.com/channels/442462691542695948/442462691542695957)
