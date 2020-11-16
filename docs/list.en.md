**Note:** _This section hasn’t been translated into English yet. The original Japanese version is below…_

# list

ポケモン赤で用いられる配列のフォーマットの一つ

## format

listのフォーマットは

```
 db エントリ数
 エントリ(何バイトでもよい)
 db 終端記号
```

で表される

## example

```asm
ListName:
    db 2        ; listのエントリ数
    db ...      ; listのエントリ1
    db ...      ; listのエントリ2
    db -1       ; 終端記号

;　engine/battle/core.asm 
OldManItemList:
	db 1 ; # items
	db POKE_BALL, 50
	db -1
```

## list menu

[list menu](./list_menu.md) 参照 

## 関連

- [DisplayListMenuID](./../home.asm)
- [list_constants.asm](./../constants/list_constants.asm)
