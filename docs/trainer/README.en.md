**Note:** _This section hasn’t been translated into English yet. The original Japanese version is below…_

# トレーナー

## Trainer Header

`Trainer Header` 1つ1つは以下のような構造をしている

```asm
TrainerHeaderLabel:
	dbEventFlagBit EVENT_ID		; 撃破フラグのあるbitを定義(下記参照)
	db ($2 << 4)				; トレーナーの視界の広さ
	dwEventFlagAddress EVENT_ID	; 撃破フラグのあるアドレスを定義(下記参照)
	dw BEFORE_BATTLE_TEXT		; 戦闘開始前のテキスト
	dw AFTER_BATTLE_TEXT		; 戦闘終了後に話しかけた時のテキスト
	dw END_BATTLE_TEXT			; 勝利時に戦闘画面で出てくるテキスト
	dw END_BATTLE_TEXT			; TODO: なぜ2つあるのか???
```

実際に定義されている例として、 `scripts/CeladonGym.asm` をみてみる

```asm
; scripts/CeladonGym.asm

CeladonGymTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_CELADON_GYM_TRAINER_0
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_CELADON_GYM_TRAINER_0
	dw CeladonGymBattleText2 ; TextBeforeBattle
	dw CeladonGymAfterBattleText2 ; TextAfterBattle
	dw CeladonGymEndBattleText2 ; TextEndBattle
	dw CeladonGymEndBattleText2 ; TextEndBattle

CeladonGymTrainerHeader1:
	dbEventFlagBit EVENT_BEAT_CELADON_GYM_TRAINER_1
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_CELADON_GYM_TRAINER_1
	dw CeladonGymBattleText3 ; TextBeforeBattle
	dw CeladonGymAfterBattleText3 ; TextAfterBattle
	dw CeladonGymEndBattleText3 ; TextEndBattle
	dw CeladonGymEndBattleText3 ; TextEndBattle

CeladonGymTrainerHeader2:
	dbEventFlagBit EVENT_BEAT_CELADON_GYM_TRAINER_2
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_CELADON_GYM_TRAINER_2
	dw CeladonGymBattleText4 ; TextBeforeBattle
	dw CeladonGymAfterBattleText4 ; TextAfterBattle
	dw CeladonGymEndBattleText4 ; TextEndBattle
	dw CeladonGymEndBattleText4 ; TextEndBattle

CeladonGymTrainerHeader3:
	dbEventFlagBit EVENT_BEAT_CELADON_GYM_TRAINER_3
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_CELADON_GYM_TRAINER_3
	dw CeladonGymBattleText5 ; TextBeforeBattle
	dw CeladonGymAfterBattleText5 ; TextAfterBattle
	dw CeladonGymEndBattleText5 ; TextEndBattle
	dw CeladonGymEndBattleText5 ; TextEndBattle

CeladonGymTrainerHeader4:
	dbEventFlagBit EVENT_BEAT_CELADON_GYM_TRAINER_4
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_CELADON_GYM_TRAINER_4
	dw CeladonGymBattleText6 ; TextBeforeBattle
	dw CeladonGymAfterBattleText6 ; TextAfterBattle
	dw CeladonGymEndBattleText6 ; TextEndBattle
	dw CeladonGymEndBattleText6 ; TextEndBattle

CeladonGymTrainerHeader5:
	dbEventFlagBit EVENT_BEAT_CELADON_GYM_TRAINER_5
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_CELADON_GYM_TRAINER_5
	dw CeladonGymBattleText7 ; TextBeforeBattle
	dw CeladonGymAfterBattleText7 ; TextAfterBattle
	dw CeladonGymEndBattleText7 ; TextEndBattle
	dw CeladonGymEndBattleText7 ; TextEndBattle

CeladonGymTrainerHeader6:
	dbEventFlagBit EVENT_BEAT_CELADON_GYM_TRAINER_6, 1
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_CELADON_GYM_TRAINER_6, 1
	dw CeladonGymBattleText8 ; TextBeforeBattle
	dw CeladonGymAfterBattleText8 ; TextAfterBattle
	dw CeladonGymEndBattleText8 ; TextEndBattle
	dw CeladonGymEndBattleText8 ; TextEndBattle

	db $ff	; 終端記号
```

`Trainer Header` はマップごとに定義され、複数存在することもある

$ff が `Trainer Header` の終端記号として使われている

## トレーナーの撃破フラグ

トレーナーの撃破フラグは、他のイベントと同じイベントフラグとして扱われており、イベントIDは `constants/event_constants.asm` で定義されている

撃破フラグを表す bit がどこにあるかは、`Trainer Header` の中で `dbEventFlagBit` と `dwEventFlagAddress` によって示されている

`dwEventFlagAddress` は撃破フラグのあるアドレスを、`dbEventFlagBit` はそのアドレスの何bit目かを示している