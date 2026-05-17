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
├── justfile                  # 入口。PROJECT 変数で対象を切替
├── gen.just                  # build_runner 系 (Freezed 等)
├── build.just                # flutter build *
├── upgrade.just              # pub upgrade 系
├── init.just                 # flutter create (足場生成)
└── projects/
    └── 01_counter_freezed/   # サンプル: Freezed + Counter
        ├── pubspec.yaml
        └── lib/
```

各チュートリアルは `projects/<番号>_<名前>/` に独立した Flutter プロジェクト
として置く。`pubspec.yaml` はプロジェクトごとに持つ。

## 新しいプロジェクトを作る

```bash
# 1. ディレクトリを決めて環境変数で指定
export PROJECT=projects/02_my_sample

# 2. 足場を生成 (web + linux)
just init platforms

# 3. 必要なら pubspec.yaml に Freezed などを追加
#    → projects/01_counter_freezed/pubspec.yaml を参考にコピー

# 4. 依存取得 → 起動
just get
just run
```

`PROJECT` を export しない場合は毎回 `just PROJECT=... <task>` で指定する。
デフォルトは `projects/01_counter_freezed`。

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

### 依存更新

```bash
just upgrade minor     # 許容範囲内で更新
just upgrade major     # メジャー含む更新 (pubspec.yaml も書き換わる)
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
