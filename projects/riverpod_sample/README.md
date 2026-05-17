# riverpod_sample

Riverpod の基本パターンを 6 つの画面に分けて確認するサンプル集。
すべて `@riverpod` アノテーション（コード生成）で書いており、
`@riverpod` を追加・変更したら `just gen build` で `.g.dart` を再生成する。

## サンプル一覧

| # | ファイル | 扱うトピック |
| - | - | - |
| 1 | [provider_sample.dart](lib/samples/provider_sample.dart) | `Provider` の基本、`ref.watch`、`keepAlive` |
| 2 | [notifier_sample.dart](lib/samples/notifier_sample.dart) | `Notifier` クラスと `state`、`ref.watch` と `ref.read(...notifier)` の使い分け |
| 3 | [future_provider_sample.dart](lib/samples/future_provider_sample.dart) | `FutureProvider`、`AsyncValue.when`、`ref.invalidate` による再フェッチ |
| 4 | [stream_provider_sample.dart](lib/samples/stream_provider_sample.dart) | `StreamProvider` の購読 |
| 5 | [family_auto_dispose_sample.dart](lib/samples/family_auto_dispose_sample.dart) | 引数付き Provider（family）と autoDispose の挙動 |
| 6 | [ref_listen_sample.dart](lib/samples/ref_listen_sample.dart) | `ref.listen` による副作用（SnackBar など）の実行 |

## 動かし方

リポジトリルートで以下を実行する。

```bash
just project set riverpod_sample
just get
just gen build
just run
```
