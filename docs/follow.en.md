**Note:** _This section hasn’t been translated into English yet. The original Japanese version is below…_

# 連行イベント

NPCによってプレイヤーが特定の場所へ歩いて連行されるイベント

ポケモン赤では以下の3種類

- マサラタウンで、オーキド博士に研究所に連行されるイベント
- ニビシティでのジムまでの強制連行イベント
- ニビシティでの美術館までの強制連行イベント

どれも [NPC movement script](./sprite/movement_script.md) を使って実現している

## マサラタウンで、オーキド博士に研究所に連行されるイベント

<img src="https://imgur.com/9HnxODN.gif" width="200px" height="180px" />

`scripts/PalletTown.asm` で `engine/overworld/npc_movement.asm` に格納された `NPC movement script` を呼び出している

連行イベント開始時に主人公が、草むらの右側にいるか左側にいるかで処理のフローが変わる

## ニビシティでのジムまでの強制連行イベント

<img src="https://imgur.com/qTnvH1C.gif" width="200px" />

`engine/overworld/npc_movement.asm` と `engine/overworld/pewter_guys.asm` で処理が定義されている

`engine/overworld/npc_movement.asm` での `NPC movement script` で決められた場所からの連行処理を行うように `scripted NPC` と `simulated joypad`が設定される

`engine/overworld/pewter_guys.asm`  の `PewterGuys` では、連行イベントの開始時の主人公のマスに応じて、上記の決められた場所に主人公が移動するように `simulated joypad` に追加の移動処理を付け加える

## ニビシティでのニビ科学博物館までの強制連行イベント

<img src="https://imgur.com/xn1PQTE.gif" width="200px" />

ニビシティでのジムまでの強制連行イベントと同様

## 関連

- [NPC movement script](./sprite/movement_script.md)
