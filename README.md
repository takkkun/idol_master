THE IDOLM@STERに関連するもののためのスクリプト
==============================================

インストール
------------

```
$ git clone https://github.com/takkkun/idol_master.git
$ cd idol_master
$ bundle
```

THE IDOLM@STER CINDERELLA GIRLS
-------------------------------

というかこのためのスクリプト。

### 手持ちのアイドルで誰が攻コスト/守コスト内に収まるかを見る

まずはユーザファイルを作成する。サンプルが用意されているので、コピーして使用する。

```
$ cp users/sample.yaml users/$(echo $USER).yaml
```

`users/あなたのユーザ名.yaml`を開き、自身のステータスや手持ちのアイドルを記述する。

```ruby
status
  offence: 100 # あなたの攻コスト
  defence: 100 # あなたの守コスト

idols:
  - 231 # [R+] 如月千早+ # http://www5164u.sakura.ne.jp/idols/IDOL_IDの値

  # レベルが最大になっていない, 親愛度が最大になっていないなどの理由で攻や守の値が
  # MMM相当でない場合は値を上書きすることも可能
  -
    id: 279 # [SR+] [孤高の歌姫]如月千早+
    offence: 11986
    defence: 9730

  # 手動で設定
  -
    name: '[瑠璃の歌姫]如月千早+'
    offence: 6646
    defence: 9957
    cost: 10
```

ユーザファイルを書き上げたら、下記のコマンドを実行することによって:

* 誰までが攻コスト内に収まるか
* 誰までが守コスト内に収まるか
* 攻コスト/守コストどちらにも収まらなかった者は誰か

が確認できる。

```
$ bundle exec rake cg:rank
```
