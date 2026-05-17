# flutter_tutorials

このリポジトリの目的は **Flutter のチュートリアルを実施すること**。
公式チュートリアルや codelab を手を動かして写経／改造しながら学ぶための
monorepo で、各チュートリアルを `projects/<番号>_<名前>/` に独立した
Flutter プロジェクトとして並べていく。devcontainer で環境を共有する。

## チュートリアル参考リンク

- [Flutter 公式ドキュメント](https://docs.flutter.dev/)
- [Get started: Write your first Flutter app (codelab)](https://docs.flutter.dev/get-started/codelab)
- [Flutter Cookbook (レシピ集)](https://docs.flutter.dev/cookbook)
- [Learn Flutter (公式学習ハブ)](https://flutter.dev/learn)
- [Dart 言語ツアー](https://dart.dev/language)

## 環境を起動する

1. VSCode で本リポジトリを開く
2. コマンドパレットから **Dev Containers: Reopen in Container**
3. 初回はイメージビルドが走る（Flutter SDK / GTK / Chromium / just を含む）

ターゲットは **Web** と **Linux desktop**。Android/iOS は含まない。

## ディレクトリ構成

```
.
├── .devcontainer/            # コンテナ定義
├── justfile                  # 入口。PROJECT で対象を切替
├── gen.just                  # build_runner 系 (Freezed 等)
├── build.just                # flutter build *
├── init.just                 # flutter create (足場生成)
├── project.just              # アクティブプロジェクトの確認/切替
└── projects/                # 各チュートリアルを配下に独立した Flutter プロジェクトとして並べる
```

各チュートリアルは `projects/<番号>_<名前>/` に独立した Flutter プロジェクト
として置く。`pubspec.yaml` はプロジェクトごとに持つ。

## アクティブプロジェクトの切替

複数プロジェクトを扱うため、コマンドの対象を `just project` で切り替える。

```bash
just project              # 現在アクティブなプロジェクトを表示 (get と同じ)
just project get          # 同上
just project set 02_my_sample   # projects/02_my_sample に切替
```

切替結果は `.active-project` ファイル (.gitignore 済) に書かれ、以降の
`just get` / `just run` などはそのプロジェクトに対して実行される。

優先順は **`PROJECT` env > `.active-project` > デフォルト (`projects/01_counter_freezed`)**。
一時的に別プロジェクトを叩きたいときは `PROJECT=projects/foo just run` のように
env で上書きする。

devcontainer の bash では `projects/<name>/` 配下に `cd` すると、そのターミナル
セッションでのみ `PROJECT` が自動的に export される ([.devcontainer/autoset.sh](.devcontainer/autoset.sh))。
配下から抜けると unset され、`.active-project` / デフォルトのフォールバックに戻る。

## 新しいプロジェクトを作る

```bash
# 1. アクティブにするプロジェクトを切替
just project set 02_my_sample

# 2. 足場を生成 (web + linux)
just init platforms

# 3. 必要なら pubspec.yaml に Freezed などを追加
#    → projects/01_counter_freezed/pubspec.yaml を参考にコピー

# 4. 依存取得 → 起動
just get
just run
```

## 開発の流れ

```bash
just get               # pub get
just gen watch         # 別ターミナルで build_runner を watch (Freezed 等)
just run               # Chrome で起動
just run linux         # Linux desktop で起動
just fmt               # dart format .
just analyze           # flutter analyze
just test              # flutter test
```

### コード生成 (Freezed / json_serializable)

`@freezed` クラスを書いたら `*.freezed.dart` / `*.g.dart` を生成する必要がある。

| コマンド            | 動作                                       |
| ------------------- | ------------------------------------------ |
| `just gen build`    | 一回限り生成 (衝突は上書き)                |
| `just gen watch`    | ファイル変更を監視して継続生成             |
| `just gen clean`    | 生成物を全削除                             |
| `just gen rebuild`  | clean → build                              |

開発中は `just gen watch` を別タブで常駐させると楽。

### ビルド

```bash
just build web         # build/web/ に出力
just build linux       # build/linux/ に出力
```

## 作法メモ

- **生成ファイルはコミットしない**: `*.freezed.dart` / `*.g.dart` は
  `.gitignore` 済み。clone 直後は `just gen build` を必ず実行する。
- **pubspec.lock もコミットしない**: 学習用のため固定しない方針。
  再現性が必要なプロジェクトでは個別に外す。
- **解析対象から生成物を除外**: `analysis_options.yaml` で
  `*.freezed.dart` / `*.g.dart` を exclude 済み。
- **プロジェクト名規則**: `projects/NN_短い名前/` (NN は連番)。
  `flutter create` の `--project-name` には `basename` がそのまま入る
  ので、ハイフンではなくアンダースコアで区切る。

## トラブルシュート

- `just gen build` で `conflicting outputs` → 既に `--delete-conflicting-outputs`
  付きなので通常は出ない。出る場合は `just gen rebuild`。
- `flutter run -d chrome` で Chrome が見つからない → コンテナ内の
  `CHROME_EXECUTABLE=/usr/bin/chromium` を確認。
- Linux desktop ビルドで GTK 関連エラー → イメージ再ビルド
  (`Dev Containers: Rebuild Container`)。
