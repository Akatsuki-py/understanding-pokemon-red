; **EnterMapAnim**  
; 主人公が、特殊な方法でマップに入ってきた時のアニメーション  
; - - -  
; 特殊な方法: そらをとぶ、 dungeon warp、 スピンしながら...
EnterMapAnim:
	call InitFacingDirectionList

	; プレイヤーを非表示?
	ld a, $ec ; $f0 -> Y=15*16px = Y = 15coord
	ld [wSpriteStateData1 + 4], a ; player's sprite Y screen position
	call Delay3
	push hl
	call GBFadeInFromWhite

	; そらをとぶ を使ってマップに入ってきた -> .flyAnimation
	ld hl, wFlags_D733
	bit 7, [hl]
	res 7, [hl]
	jr nz, .flyAnimation

	ld a, SFX_TELEPORT_ENTER_1
	call PlaySound

	; dungeon warp を使ってマップに入ってきた -> .dungeonWarpAnimation
	ld hl, wd732
	bit 4, [hl]
	res 4, [hl]
	pop hl
	jr nz, .dungeonWarpAnimation

	; この時点でプレイヤーはテレポートやあなぬけのひもを使ってワープしてきたので着地処理を行う (https://imgur.com/9N7Ber9.gif)

	; 降下処理
	call PlayerSpinWhileMovingDown
	ld a, SFX_TELEPORT_ENTER_2
	call PlaySound

	; 入ってきたマップの足下に テレポート床か穴 があった -> .done
	call IsPlayerStandingOnWarpPadOrHole
	ld a, b
	and a
	jr nz, .done

	; この時点でプレイヤーはテレポート床や穴の上にいない
	; プレイヤーを着地地点でスピンさせる(https://imgur.com/lLnNDTD.gif)
	ld hl, wPlayerSpinInPlaceAnimFrameDelay
	xor a
	ld [hli], a		; [wPlayerSpinInPlaceAnimFrameDelay] = 0
	inc a
	ld [hli], a		; [wPlayerSpinInPlaceAnimFrameDelayDelta] = 1
	ld a, $8
	ld [hli], a		; [wPlayerSpinInPlaceAnimFrameDelayEndValue] = 8
	ld [hl], $ff 	; [wPlayerSpinInPlaceAnimSoundID] = 0xff
	ld hl, wFacingDirectionList
	call PlayerSpinInPlace

.restoreDefaultMusic
	call PlayDefaultMusic

.done
	jp RestoreFacingDirectionAndYScreenPos	; return
	
; dungeon warp でマップに入ってきた時
.dungeonWarpAnimation
	; 画面真っ白の状態で 50フレーム待機
	ld c, 50
	call DelayFrames
	; 落ちてくるアニメーション
	call PlayerSpinWhileMovingDown
	jr .done

; そらをとぶ でマップに入ってきた時
.flyAnimation
	pop hl

	; プレイヤーのスプライトを鳥にする
	; LoadBirdSpriteGraphicsと重複してるので不要？ {
	ld de, BirdSprite
	ld hl, vNPCSprites
	lb bc, BANK(BirdSprite), $0c
	call CopyVideoData ; }
	call LoadBirdSpriteGraphics

	; 空を飛ぶサウンド
	ld a, SFX_FLY
	call PlaySound

	; wFlyAnimUsingCoordList に各種変数を配置
	ld hl, wFlyAnimUsingCoordList
	
	; [wFlyAnimUsingCoordList] = 0 (アニメーションで鳥を動かすように)
	xor a
	ld [hli], a
	
	; [wFlyAnimCounter] = 12 (アニメーションは全部で 12コマ)
	ld a, 12
	ld [hli], a
	
	; [wFlyAnimBirdSpriteImageIndex] = 8 (右を向いている)
	ld [hl], $8
	
	; 鳥が降り立つアニメーションを流す
	ld de, FlyAnimationEnterScreenCoords
	call DoFlyAnimation

	; 主人公のスプライトを元に戻す
	call LoadPlayerSpriteGraphics
	jr .restoreDefaultMusic

; **FlyAnimationEnterScreenCoords**  
; 主人公が そらをとぶ でマップに降り立つ時のアニメーションの座標  
; - - -  
; 各エントリ = [y, x]  
FlyAnimationEnterScreenCoords:
	db $05, $98	; wFlyAnimCounter = 1
	db $0F, $90
	db $18, $88
	db $20, $80
	db $27, $78
	db $2D, $70
	db $32, $68
	db $36, $60
	db $39, $58
	db $3B, $50
	db $3C, $48
	db $3C, $40	; wFlyAnimCounter = 12

; PlayerSpinWhileMovingDown  
; プレイヤーをスピンしながら降下させる処理  
; - - -  
; あなぬけのひも や テレポート で利用  
PlayerSpinWhileMovingDown:
	ld hl, wPlayerSpinWhileMovingUpOrDownAnimDeltaY
	
	; [wPlayerSpinWhileMovingUpOrDownAnimDeltaY] = 0x10
	ld a, $10
	ld [hli], a

	; [wPlayerSpinWhileMovingUpOrDownAnimMaxY] = 0x3c
	ld a, $3c
	ld [hli], a

	; [wPlayerSpinWhileMovingUpOrDownAnimFrameDelay] = 0x03 (SGBなら 0x02)
	; 方向としては下向きとして扱われる(0: 下, 4: 上, 8: 左, $c: 右 なので)
	call GetPlayerTeleportAnimFrameDelay
	ld [hl], a

	jp PlayerSpinWhileMovingUpOrDown ; ret

_LeaveMapAnim:
	call InitFacingDirectionList
	call IsPlayerStandingOnWarpPadOrHole
	ld a, b
	and a
	jr z, .playerNotStandingOnWarpPadOrHole
	dec a
	jp nz, LeaveMapThroughHoleAnim
.spinWhileMovingUp
	ld a, SFX_TELEPORT_EXIT_1
	call PlaySound
	ld hl, wPlayerSpinWhileMovingUpOrDownAnimDeltaY
	ld a, -$10
	ld [hli], a ; wPlayerSpinWhileMovingUpOrDownAnimDeltaY
	ld a, $ec
	ld [hli], a ; wPlayerSpinWhileMovingUpOrDownAnimMaxY
	call GetPlayerTeleportAnimFrameDelay
	ld [hl], a ; wPlayerSpinWhileMovingUpOrDownAnimFrameDelay
	call PlayerSpinWhileMovingUpOrDown
	call IsPlayerStandingOnWarpPadOrHole
	ld a, b
	dec a
	jr z, .playerStandingOnWarpPad
; if not standing on a warp pad, there is an extra delay
	ld c, 10
	call DelayFrames
.playerStandingOnWarpPad
	call GBFadeOutToWhite
	jp RestoreFacingDirectionAndYScreenPos
.playerNotStandingOnWarpPadOrHole
	ld a, $4
	call StopMusic
	ld a, [wd732]
	bit 6, a ; is the last used pokemon center the destination?
	jr z, .flyAnimation
; if going to the last used pokemon center
	ld hl, wPlayerSpinInPlaceAnimFrameDelay
	ld a, 16
	ld [hli], a ; wPlayerSpinInPlaceAnimFrameDelay
	ld a, -1
	ld [hli], a ; wPlayerSpinInPlaceAnimFrameDelayDelta
	xor a
	ld [hli], a ; wPlayerSpinInPlaceAnimFrameDelayEndValue
	ld [hl], SFX_TELEPORT_EXIT_2 ; wPlayerSpinInPlaceAnimSoundID
	ld hl, wFacingDirectionList
	call PlayerSpinInPlace
	jr .spinWhileMovingUp
.flyAnimation
	call LoadBirdSpriteGraphics
	ld hl, wFlyAnimUsingCoordList
	ld a, $ff ; is not using coord list (flap in place)
	ld [hli], a ; wFlyAnimUsingCoordList
	ld a, 8
	ld [hli], a ; wFlyAnimCounter
	ld [hl], $c ; wFlyAnimBirdSpriteImageIndex
	call DoFlyAnimation
	ld a, SFX_FLY
	call PlaySound
	ld hl, wFlyAnimUsingCoordList
	xor a ; is using coord list
	ld [hli], a ; wFlyAnimUsingCoordList
	ld a, $c
	ld [hli], a ; wFlyAnimCounter
	ld [hl], $c ; wFlyAnimBirdSpriteImageIndex (facing right)
	ld de, FlyAnimationScreenCoords1
	call DoFlyAnimation
	ld c, 40
	call DelayFrames
	ld hl, wFlyAnimCounter
	ld a, 11
	ld [hli], a ; wFlyAnimCounter
	ld [hl], $8 ; wFlyAnimBirdSpriteImageIndex (facing left)
	ld de, FlyAnimationScreenCoords2
	call DoFlyAnimation
	call GBFadeOutToWhite
	jp RestoreFacingDirectionAndYScreenPos

FlyAnimationScreenCoords1:
; y, x pairs
; This is the sequence of screen coordinates used by the first part
; of the Fly overworld animation.
	db $3C, $48
	db $3C, $50
	db $3B, $58
	db $3A, $60
	db $39, $68
	db $37, $70
	db $37, $78
	db $33, $80
	db $30, $88
	db $2D, $90
	db $2A, $98
	db $27, $A0

FlyAnimationScreenCoords2:
; y, x pairs
; This is the sequence of screen coordinates used by the second part
; of the Fly overworld animation.
	db $1A, $90
	db $19, $80
	db $17, $70
	db $15, $60
	db $12, $50
	db $0F, $40
	db $0C, $30
	db $09, $20
	db $05, $10
	db $00, $00

	db $F0, $00

LeaveMapThroughHoleAnim:
	ld a, $ff
	ld [wUpdateSpritesEnabled], a ; disable UpdateSprites
	; shift upper half of player's sprite down 8 pixels and hide lower half
	ld a, [wOAMBuffer + 0 * 4 + 2]
	ld [wOAMBuffer + 2 * 4 + 2], a
	ld a, [wOAMBuffer + 1 * 4 + 2]
	ld [wOAMBuffer + 3 * 4 + 2], a
	ld a, $a0
	ld [wOAMBuffer + 0 * 4], a
	ld [wOAMBuffer + 1 * 4], a
	ld c, 2
	call DelayFrames
	; hide upper half of player's sprite
	ld a, $a0
	ld [wOAMBuffer + 2 * 4], a
	ld [wOAMBuffer + 3 * 4], a
	call GBFadeOutToWhite
	ld a, $1
	ld [wUpdateSpritesEnabled], a ; enable UpdateSprites
	jp RestoreFacingDirectionAndYScreenPos

; **DoFlyAnimation**  
; そらをとぶ で鳥がとぶアニメーション  
; - - -  
; 関数1回で 1コマ を担当 ループ処理によってアニメーションを作る  
; 
; INPUT: de = 鳥の座標のテーブルのアドレス(各エントリ = [y, x])
; ![そらをとぶ](https://imgur.com/8krS55b.gif)
DoFlyAnimation:
	; 鳥のスプライトを立っている状態と羽を出している状態で切り替えて羽ばたいているように見せる
	ld a, [wFlyAnimBirdSpriteImageIndex]
	xor $1	; ここで切り替えている
	ld [wFlyAnimBirdSpriteImageIndex], a
	ld [wSpriteStateData1 + 2], a
	call Delay3

	; [wFlyAnimUsingCoordList] == 0xff なら 鳥をその場で羽ばたかせる処理をさせる -> .skipCopyingCoords
	ld a, [wFlyAnimUsingCoordList]
	cp $ff
	jr z, .skipCopyingCoords

	; 鳥スプライトの座標に de で指定したテーブルの座標を書き込む
	ld hl, wSpriteStateData1 + 4
	; Y座標を更新 ([$c104] = [de++])
	ld a, [de]
	inc de
	ld [hli], a
	; X座標を更新 ([$c106] = [de++])
	inc hl
	ld a, [de]
	inc de
	ld [hl], a

.skipCopyingCoords
	; [wFlyAnimCounter]を減らして 0 になったら終了 そうでないならもう一度call
	ld a, [wFlyAnimCounter]
	dec a
	ld [wFlyAnimCounter], a
	jr nz, DoFlyAnimation
	ret

; **LoadBirdSpriteGraphics**  
; VRAM上の主人公の2bppタイルデータを鳥の2bppデータで上書きし、主人公の見た目を鳥にする
LoadBirdSpriteGraphics:
	; 主人公の立ち姿のところに鳥
	ld de, BirdSprite
	ld hl, vNPCSprites
	lb bc, BANK(BirdSprite), $0c
	call CopyVideoData

	; 主人公の歩き姿のところに羽ばたく鳥
	ld de, BirdSprite + $c0 ; moving animation sprite
	ld hl, vNPCSprites2
	lb bc, BANK(BirdSprite), $0c
	jp CopyVideoData

; **InitFacingDirectionList**  
; プレイヤーの状態を保存し、 `wFacingDirectionList` を初期化する
; - - -  
; OUTPUT:  
; [wSavedPlayerFacingDirection] = プレイヤーの方向  
; [wSavedPlayerScreenY] = プレイヤーのY座標  
; hl = wFacingDirectionList(下) or wFacingDirectionList+1(左) or wFacingDirectionList+2(上) or wFacingDirectionList+3(右)  
InitFacingDirectionList:
	; [wSavedPlayerFacingDirection] = プレイヤーの sprite image index
	ld a, [wSpriteStateData1 + 2] ; sprite image index(c1x2)
	ld [wSavedPlayerFacingDirection], a

	; [wSavedPlayerScreenY] = プレイヤーのY座標
	ld a, [wSpriteStateData1 + 4]
	ld [wSavedPlayerScreenY], a

	; PlayerSpinningFacingOrder -> wFacingDirectionList にコピー (spinデータを init)
	ld hl, PlayerSpinningFacingOrder
	ld de, wFacingDirectionList
	ld bc, 4
	call CopyData

; wFacingDirectionList をプレイヤーの向いている方向にセットする
	ld a, [wSpriteStateData1 + 2] ; a = プレイヤーの現在向いている方向 (c1x2 プレイヤーなのでVRAMオフセット0, 立っているのでanime frameも0)
	ld hl, wFacingDirectionList
.loop ; {
	cp [hl]
	inc hl
	jr nz, .loop
; }
	dec hl	; hl = wFacingDirectionList(下) or wFacingDirectionList+1(左) or wFacingDirectionList+2(上) or wFacingDirectionList+3(右)

	ret

; **PlayerSpinningFacingOrder**  
; プレイヤーが、テレポートなどでスピンしながらマップ移動するときのスピンの順番  
; - - -  
; db SPRITE_FACING_DOWN, SPRITE_FACING_LEFT, SPRITE_FACING_UP, SPRITE_FACING_RIGHT
PlayerSpinningFacingOrder:
	db SPRITE_FACING_DOWN, SPRITE_FACING_LEFT, SPRITE_FACING_UP, SPRITE_FACING_RIGHT	; ↓ ← ↑ →

; **SpinPlayerSprite**  
; sprite image indexをプレイヤーが回転するようにし、wFacingDirectionListの中身を前にずらす(前方向に回転させる)  
; - - -  
; data[3] <- data[0] <- data[1] <- data[2] <- data[3] <- data[0] <- ...
; 
; INPUT: [hl] = sprite image index(プレイヤーのスピン処理で向いている方向を変えるのに利用)
SpinPlayerSprite:
	ld a, [hl]
	ld [wSpriteStateData1 + 2], a ; player's sprite facing direction (image index is locked to standing images)

	push hl

	; wFacingDirectionListを前方向に回転(data[3] <- data[0] <- data[1] <- data[2] <- data[3] <- data[0])
	ld hl, wFacingDirectionList
	ld de, wFacingDirectionList - 1
	ld bc, 4
	call CopyData
	ld a, [wFacingDirectionList - 1]
	ld [wFacingDirectionList + 3], a

	pop hl
	ret

; **PlayerSpinInPlace**  
; プレイヤーのスプライトをその場でスピンさせる処理  
; - - -  
; 1回の処理では、1方向転換分を担当し、ループ実行によって回転終了までを担当する  
; 回転終了に近くにつれて、徐々にスピンは遅くなっていく  
; ![example](https://imgur.com/lLnNDTD.gif)  
PlayerSpinInPlace:
	call SpinPlayerSprite

	; [wPlayerSpinInPlaceAnimFrameDelay]%4 > 0 -> .skipPlayingSound
	ld a, [wPlayerSpinInPlaceAnimFrameDelay]
	ld c, a
	and $3
	jr nz, .skipPlayingSound

	; [wPlayerSpinInPlaceAnimFrameDelay]%4 == 0 のときは スピンサウンドを流す
	ld a, [wPlayerSpinInPlaceAnimSoundID]
	cp $ff
	call nz, PlaySound

.skipPlayingSound
	; Delay時間を増やしてスピンが遅くなっていくようにする
	ld a, [wPlayerSpinInPlaceAnimFrameDelayDelta]
	add c
	ld [wPlayerSpinInPlaceAnimFrameDelay], a	; [wPlayerSpinInPlaceAnimFrameDelay] += [wPlayerSpinInPlaceAnimFrameDelayDelta]
	ld c, a	; c = [wPlayerSpinInPlaceAnimFrameDelay]

	; Delayが終了 -> return
	ld a, [wPlayerSpinInPlaceAnimFrameDelayEndValue]
	cp c
	ret z

	; [wPlayerSpinInPlaceAnimFrameDelay]フレーム だけDelay処理してもう一度
	call DelayFrames
	jr PlayerSpinInPlace

; **PlayerSpinWhileMovingUpOrDown**  
; プレイヤーを下方向に移動させつつスピンさせる  
; - - -  
; 1回の処理では、1方向転換分を担当し、ループ実行によって回転し初めから回転終了の全期間を担当する  
PlayerSpinWhileMovingUpOrDown:
	call SpinPlayerSprite
	
	; プレイヤーのY座標を wPlayerSpinWhileMovingUpOrDownAnimDeltaY の分だけずらす
	ld a, [wPlayerSpinWhileMovingUpOrDownAnimDeltaY]
	ld c, a
	ld a, [wSpriteStateData1 + 4] 	; $c104 = プレイヤーのY座標
	add c
	ld [wSpriteStateData1 + 4], a	; [$c104] += [wPlayerSpinWhileMovingUpOrDownAnimDeltaY]
	ld c, a	; c = [$c104]

	; プレイヤーのY座標が [wPlayerSpinWhileMovingUpOrDownAnimMaxY] まで降りてきたら終了
	ld a, [wPlayerSpinWhileMovingUpOrDownAnimMaxY]
	cp c
	ret z

	; [wPlayerSpinWhileMovingUpOrDownAnimFrameDelay]フレーム だけ delay
	ld a, [wPlayerSpinWhileMovingUpOrDownAnimFrameDelay]
	ld c, a
	call DelayFrames

	jr PlayerSpinWhileMovingUpOrDown

; [wSavedPlayerScreenY] と [wSavedPlayerFacingDirection] に保存した値を復帰  
; 
; OUTPUT:  
; [$c102] = [wSavedPlayerFacingDirection]  
; [$c104] = [wSavedPlayerScreenY]  
RestoreFacingDirectionAndYScreenPos:
	ld a, [wSavedPlayerScreenY]
	ld [wSpriteStateData1 + 4], a
	ld a, [wSavedPlayerFacingDirection]
	ld [wSpriteStateData1 + 2], a
	ret


; OUTPUT: a = 3 frames (if SGB, 2 frames)
GetPlayerTeleportAnimFrameDelay:
	ld a, [wOnSGB]
	xor $1
	inc a
	inc a
	ret

; **IsPlayerStandingOnWarpPadOrHole**  
; プレイヤーが現在 dungeon warp のタイルとして使われるタイルの上に乗っているか  
; - - -  
; OUTPUT: b = [wStandingOnWarpPadOrHole] = ID (0(乗ってない) or .warpPadAndHoleDataで設定された乗っているタイルのID)  
IsPlayerStandingOnWarpPadOrHole:
	ld b, 0
	ld hl, .warpPadAndHoleData
	ld a, [wCurMapTileset]
	ld c, a	; c = [wCurMapTileset]

; .warpPadAndHoleDataの中からプレイヤーの立っているタイル番号と同じものがあるかみていく
.loop
; {
	ld a, [hli]

	; 見つからなかった -> .done
	cp $ff
	jr z, .done

	; タイルセットが違う
	cp c
	jr nz, .nextEntry

	; 見つかった -> .foundMatch
	aCoord 8, 9
	cp [hl]
	jr z, .foundMatch

.nextEntry
	inc hl
	inc hl
	jr .loop
; }

.foundMatch
	inc hl
	ld b, [hl] ; b = ID
.done
	ld a, b
	ld [wStandingOnWarpPadOrHole], a
	ret

; db タイルセットID, タイル番号, [wStandingOnWarpPadOrHole]に格納されるID
.warpPadAndHoleData:
	db FACILITY, $20, 1 ; テレポート床
	db FACILITY, $11, 2 ; 穴
	db CAVERN,   $22, 2 ; 穴
	db INTERIOR, $55, 1 ; テレポート床
	db $FF

FishingAnim:
	ld c, 10
	call DelayFrames
	ld hl, wd736
	set 6, [hl] ; reserve the last 4 OAM entries
	ld de, RedSprite
	ld hl, vNPCSprites
	lb bc, BANK(RedSprite), $c
	call CopyVideoData
	ld a, $4
	ld hl, RedFishingTiles
	call LoadAnimSpriteGfx
	ld a, [wSpriteStateData1 + 2]
	ld c, a
	ld b, $0
	ld hl, FishingRodOAM
	add hl, bc
	ld de, wOAMBuffer + $9c
	ld bc, $4
	call CopyData
	ld c, 100
	call DelayFrames
	ld a, [wRodResponse]
	and a
	ld hl, NoNibbleText
	jr z, .done
	cp $2
	ld hl, NothingHereText
	jr z, .done

; there was a bite

; shake the player's sprite vertically
	ld b, 10
.loop
	ld hl, wSpriteStateData1 + 4 ; player's sprite Y screen position
	call .ShakePlayerSprite
	ld hl, wOAMBuffer + $9c
	call .ShakePlayerSprite
	call Delay3
	dec b
	jr nz, .loop

; If the player is facing up, hide the fishing rod so it doesn't overlap with
; the exclamation bubble that will be shown next.
	ld a, [wSpriteStateData1 + 2] ; player's sprite facing direction
	cp SPRITE_FACING_UP
	jr nz, .skipHidingFishingRod
	ld a, $a0
	ld [wOAMBuffer + $9c], a

.skipHidingFishingRod
	ld hl, wEmotionBubbleSpriteIndex
	xor a
	ld [hli], a ; player's sprite
	ld [hl], a ; EXCLAMATION_BUBBLE
	predef EmotionBubble

; If the player is facing up, unhide the fishing rod.
	ld a, [wSpriteStateData1 + 2] ; player's sprite facing direction
	cp SPRITE_FACING_UP
	jr nz, .skipUnhidingFishingRod
	ld a, $44
	ld [wOAMBuffer + $9c], a

.skipUnhidingFishingRod
	ld hl, ItsABiteText

.done
	call PrintText
	ld hl, wd736
	res 6, [hl] ; unreserve the last 4 OAM entries
	call LoadFontTilePatterns
	ret

.ShakePlayerSprite
	ld a, [hl]
	xor $1
	ld [hl], a
	ret

; "Not even a nibble!" (釣りでポケモンが食いつかなかった)
NoNibbleText:
	TX_FAR _NoNibbleText
	db "@"

; "Looks like there's nothing here."
NothingHereText:
	TX_FAR _NothingHereText
	db "@"

; "Oh! It's a bite!" (釣りでヒットした)
ItsABiteText:
	TX_FAR _ItsABiteText
	db "@"

FishingRodOAM:
; specifies how the fishing rod should be drawn on the screen
; first byte = screen y coordinate
; second byte = screen x coordinate
; third byte = tile number
; fourth byte = sprite properties
	db $5B, $4C, $FD, $00 ; player facing down
	db $44, $4C, $FD, $00 ; player facing up
	db $50, $40, $FE, $00 ; player facing left
	db $50, $58, $FE, $20 ; player facing right ($20 means "horizontally flip the tile")

RedFishingTiles:
	dw RedFishingTilesFront
	db 2, BANK(RedFishingTilesFront)
	dw vNPCSprites + $20

	dw RedFishingTilesBack
	db 2, BANK(RedFishingTilesBack)
	dw vNPCSprites + $60

	dw RedFishingTilesSide
	db 2, BANK(RedFishingTilesSide)
	dw vNPCSprites + $a0

	dw RedFishingRodTiles
	db 3, BANK(RedFishingRodTiles)
	dw vNPCSprites2 + $7d0

; **_HandleMidJump**  
; プレイヤーがマップ上の段差から飛び降りた時のアニメーション処理
_HandleMidJump:
	; a = [wPlayerJumpingYScreenCoordsIndex] + 1
	ld a, [wPlayerJumpingYScreenCoordsIndex]
	ld c, a
	inc a

	; a == 0x10(16) つまり 段差からジャンプするアニメーションを終えた -> .finishedJump
	cp $10	; 
	jr nc, .finishedJump

	; [wPlayerJumpingYScreenCoordsIndex] = [wPlayerJumpingYScreenCoordsIndex] + 1
	ld [wPlayerJumpingYScreenCoordsIndex], a

	; 主人公の Y px を更新して終了
	ld b, 0
	ld hl, PlayerJumpingYScreenCoords
	add hl, bc
	ld a, [hl]
	ld [wSpriteStateData1 + 4], a ; 0xc1X4
	ret

.finishedJump
	; 段差からジャンプするアニメーションを終えた ときの処理
	; 変数やフラグ、キー入力の状態をクリアして終了

	; [wWalkCounter] > 0 -> return
	ld a, [wWalkCounter]
	cp 0
	ret nz

	; [wWalkCounter] == 0 のとき
	; TODO: [wWalkCounter] が 0であることをチェックする理由は?

	call UpdateSprites
	call Delay3

	xor a
	
	; キー入力をリセット
	ld [hJoyHeld], a
	ld [hJoyPressed], a
	ld [hJoyReleased], a

	; [wPlayerJumpingYScreenCoordsIndex] = 0
	ld [wPlayerJumpingYScreenCoordsIndex], a

	ld hl, wd736
	res 6, [hl] ; 段差ジャンプ時にセットされるフラグをクリア
	ld hl, wd730
	res 7, [hl] ; simulated joypad 状態をクリア

	xor a
	ld [wJoyIgnore], a ; [wJoyIgnore] = 0
	ret

; PlayerJumpingYScreenCoords + i = 段差からジャンプして iフレーム目(段差ジャンプは 16フレーム で終わり) でのスプライトの Y座標(px)
PlayerJumpingYScreenCoords:
	db $38, $36, $34, $32, $31, $30, $30, $30, $31, $32, $33, $34, $36, $38, $3C, $3C
