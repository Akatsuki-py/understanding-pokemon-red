**Note:** _This section hasn’t been translated into English yet. The original Japanese version is below…_

# intro

ゲーム開始時のアニメーションのこと

![intro](https://imgur.com/SSy2Bsm.gif)

`PlayIntro` から処理が始まる

## PlayShootingStar

コピーライト + ゲーフリロゴ のアニメーションを流す

![gamefreak](https://imgur.com/Gsei531.gif)

 処理の大半を内部の `AnimateShootingStar` で行っている  

 `AnimateShootingStar` では `CheckForUserInterruption` でユーザーのキー入力チェックを行っていて、特定のキーが押されたときは、アニメーションをスキップしている

## PlayIntroScene

ここでゲンガーとニドリーノが戦っているアニメーションを流す

ゲンガーは 背景として描画されているが、ニドリーノは スプライトとして配置されている

`IntroMoveMon` でニドリーノやゲンガーを動かしたりする処理を行っている

最初にゲンガーとニドリーノが画面端から所定の位置にスライドする処理があるが、これは、ゲンガーは背景なのでSCXをずらすつまりスクロールすることで、ニドリーノはOAMのXYプロパティを変更することで行っている
