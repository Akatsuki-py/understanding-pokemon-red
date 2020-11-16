**Note:** _This section hasn’t been translated into English yet. The original Japanese version is below…_

# マクロ

`rgbasm`では以下のようにしてマクロを定義できる

```asm
MyMacro: MACRO
        ld   a,80
        call MyFunc
        ENDM
```

また定義したマクロは次のように実行できる

```asm
add a,b
ld sp,hl
MyMacro ; ここでマクロが展開される
sub a,87
```

またマクロから別のマクロを呼ぶことも可能となっている

`rgbasm`は`MyMacro`を発見するとそこをマクロの定義で置き換える

マクロの定義とはMACRO/ENDMで囲まれた部分を指す

