**Note:** _This section hasn’t been translated into English yet. The original Japanese version is below…_

# simulated joypad

ポケモン赤にシミュレートされたキー入力のこと  
つまりプレイヤーがゲームによって勝手にキー入力をされている状態  

pewter guyなどNPCの強制連行イベントなどでこの状態になる

## description

- wSimulatedJoypadStatesEnd
- wSimulatedJoypadStatesIndex

の2種類のアドレスの値が`simulated joypad`と関連している

プレイヤーの`simulated joypad`によるキー入力は`wSimulatedJoypadStatesEnd + [wSimulatedJoypadStatesIndex]`のアドレスに格納された値となる

値のフォーマットは、次のように `simulated joypad` の入力方向が入る

```asm
D_RIGHT  EQU %00010000
D_LEFT   EQU %00100000
D_UP     EQU %01000000
D_DOWN   EQU %10000000
```

`simulated joypad` の1入力のたびに`wSimulatedJoypadStatesIndex`の値がデクリメントされ、`wSimulatedJoypadStatesEnd + [wSimulatedJoypadStatesIndex]`の値が`wSimulatedJoypadStatesEnd`と等しいとき、つまり`[wSimulatedJoypadStatesIndex]`が0のときに`simulated joypad`状態は終了する

## example

例えば、プレイヤーを 上->上->右->下 と動かす場合は次のように `wSimulatedJoypadStatesEnd` と `wSimulatedJoypadStatesIndex` は次のようになっている

```
wSimulatedJoypadStatesEnd       -> D_DOWN
wSimulatedJoypadStatesEnd + 1   -> D_RIGHT
wSimulatedJoypadStatesEnd + 2   -> D_UP
wSimulatedJoypadStatesEnd + 3   -> D_UP

wSimulatedJoypadStatesIndex -> 4
```

