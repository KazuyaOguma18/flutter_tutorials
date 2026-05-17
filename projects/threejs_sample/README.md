# threejs_sample

[three_js](https://pub.dev/packages/three_js) (Knightro 製、three.js の Dart 移植) で
3D 描画の基本要素を 4 画面に分けて確認するサンプル集。
メニューから各サンプルへ遷移する構成で、サンプルごとに `ThreeJS` を 1 つ持ち、
`setup()` で `Scene` を組み立て、`addAnimationEvent` で毎フレーム更新する。

## サンプル一覧

| # | ファイル | 扱うトピック |
| - | - | - |
| 1 | [basics_sample.dart](lib/samples/basics_sample.dart) | `Scene` / `PerspectiveCamera` / `BoxGeometry`・`SphereGeometry`・`PlaneGeometry` / `MeshPhongMaterial`、アニメーションループでの回転 |
| 2 | [lighting_sample.dart](lib/samples/lighting_sample.dart) | `AmbientLight` / `DirectionalLight` / `PointLight` / `SpotLight` と `Settings.enableShadowMap` + `castShadow` / `receiveShadow` による影 |
| 3 | [texture_sample.dart](lib/samples/texture_sample.dart) | `ImageElement` から `CanvasTexture` を作る (アセットなしの procedural)、`RepeatWrapping`、`MeshBasic` / `MeshPhong` / `MeshStandard` (PBR) の比較 |
| 4 | [controls_sample.dart](lib/samples/controls_sample.dart) | `OrbitControls` のマウス/タッチ操作 (damping)、`addAnimationEvent` での周回アニメーション、`GLTFLoader` + `AnimationMixer` の呼び出し例 (コメント) |

## 動かし方

リポジトリルートで以下を実行する。

```bash
just project set threejs_sample
just get
just run               # Chrome
just run linux         # Linux desktop
```

## プラットフォームメモ

- **Web**: WebGL2 経由で描画。`flutter_angle` の js_interop ブリッジが必要なので
  [web/index.html](web/index.html) で `gles_bindings.js` を読み込んでいる。
- **Linux desktop**: three_js のドキュメント上は Flutter < 3.27 のみ対応。
  動かない場合はサンプル側ではなく three_js の対応状況を疑う。

## モデル (GLTF/GLB) を試したい場合

[controls_sample.dart](lib/samples/controls_sample.dart) の末尾コメントを参照。
`assets/models/*.glb` を置き、[pubspec.yaml](pubspec.yaml) の `flutter.assets` に
登録した上でコメントブロックを有効化すると `GLTFLoader` → `AnimationMixer` まで動く。

## 参考リンク

- [three.js manual (本家)](https://threejs.org/manual/) — three_js は API も命名もこれに倣っている
