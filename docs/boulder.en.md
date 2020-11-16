**Note:** _This section hasn’t been translated into English yet. The original Japanese version is below…_

# Boulder

![intro](https://imgur.com/qtnX0lI.gif)

『かいりき』で押せる岩のこと。 以後、かいりき岩と呼ぶ

音声付きの動画でみたい場合は [Pokemon Red Part 45 - Charizard Vs Blastoise](https://youtu.be/M2R5e02QHKI?t=576)参照

かいりきに関する処理は、主に `engine/overworld/push_boulder.asm` で記述されている

## RunMapScript

かいりきの処理は `home/overworld.asm` の `RunMapScript` で Map scriptとして実行される

Map scriptについてはおそらくMap上で定期的に実行される処理だと思われる(TODO)

かいりきの処理は `RunMapScript` の `TryPushingBoulder` と `DoBoulderDustAnimation` の2段階にわけて行われる

## TryPushingBoulder

プレイヤーのキー入力、向いている方向やかいりき岩とのマップ上の位置関係や障害物を考慮して、主人公がかいりき岩を押している状態なのかを判定する

かいりき岩を押している状態ならば、かいりき岩のスプライトを移動させ、サウンドを流し、wFlags_0xcd60の bit1 をセットして return する 

## DoBoulderDustAnimation

`RunMapScript` で wFlags_0xcd60の bit1 がセットされているとき、つまり `TryPushingBoulder` でかいりき岩を押している状態と判断されたときに発火する関数。

かいりき岩を押したあとの土埃の処理を行っている
