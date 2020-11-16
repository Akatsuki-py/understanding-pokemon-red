**Note:** _This section hasn’t been translated into English yet. The original Japanese version is below…_

# Path

ここでは、NPCがイベントでプレイヤーのもとへ歩いてくるときの道筋のことを指す

## Pathに関する変数

- hFindPathNumSteps: Pathの歩数
- hFindPathFlags: Pathが見つかったかを示すフラグ
- hFindPathYProgress: PathのY歩数
- hFindPathXProgress: PathのX歩数

## Pathの探索

Pathの探索は `engine/pathfinding.asm` の `FindPathToPlayer`関数 で行われる

探索の手順は、

1. hNPCPlayerXDistance, hNPCPlayerYDistanceと上記変数からプレイヤーとNPCのX距離、Y距離を計算
2. X距離、Y距離、hNPCPlayerRelativePosFlagsからNPCの進行方向を1歩分決める
3. 1,2をNPCがプレイヤーのところに到達するまで繰り返す

このループが終わったとき、hFindPathXProgress、hFindPathYProgressにPathの歩数情報が格納されている

あとはこの通りにNPCを動かせば目的のところ(プレイヤーのところ)までたどり着く

