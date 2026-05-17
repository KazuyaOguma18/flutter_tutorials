# counter_freezed

Flutter の最も簡単な状態管理 (`setState` ベース) を題材に、
状態クラスを Freezed で定義する練習プロジェクト。

## freezed を使う意義

`CounterState` のような不変な値クラスを書くと、本来は `==` / `hashCode` /
`copyWith` / `toString` を毎回手書きすることになる。Freezed を入れると
これらが `*.freezed.dart` に自動生成され、`factory` 1 行で値クラスの
形を宣言できる。

- **`copyWith`**: `_state.copyWith(count: _state.count + 1)` のように
  差分だけ書いて新インスタンスを得る。`setState` で「現在の状態から
  差分を作って置き換える」 パターンに素直に収まる。
- **値等価**: 内容が同じなら `==` が成立。後で `select` 系の
  再ビルド最適化や状態比較を入れるときに前提が揃う。
- **JSON 連携**: `json_serializable` を併用すると `fromJson` / `toJson`
  も同居でき、永続化や API 連携に状態クラスをそのまま再利用できる。
- **sealed union**: 今回は単一形だが、`Loading | Loaded | Error` の
  ような直和に育てても switch の網羅性チェックがコンパイル時に効く。

定義変更は `build_runner` が追随するので、フィールドの増減・改名でも
boilerplate を書き直す必要がない。
