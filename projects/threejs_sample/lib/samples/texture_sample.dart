import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:three_js/three_js.dart' as three;

/// 03. テクスチャ & マテリアル拡張
///
///   - `ImageElement` + `CanvasTexture` で手書き (procedural) のテクスチャを生成
///   - `RepeatWrapping` でタイル状に貼り付け
///   - `MeshStandardMaterial` (PBR) の `roughness` / `metalness` を比較
///   - `MeshBasicMaterial` / `MeshPhongMaterial` / `MeshStandardMaterial` を並べる
class TextureSamplePage extends StatefulWidget {
  const TextureSamplePage({super.key});

  @override
  State<TextureSamplePage> createState() => _TextureSamplePageState();
}

class _TextureSamplePageState extends State<TextureSamplePage> {
  late final three.ThreeJS threeJs;

  @override
  void initState() {
    super.initState();
    threeJs = three.ThreeJS(
      onSetupComplete: () => setState(() {}),
      setup: _setup,
      settings: three.Settings(
        enableShadowMap: true,
        shadowMapType: three.PCFSoftShadowMap,
      ),
    );
  }

  @override
  void dispose() {
    threeJs.dispose();
    super.dispose();
  }

  /// 8x8 のチェッカーパターンを生成し、`CanvasTexture` に渡せる
  /// `ImageElement` を返す。アセットを用意せずにテクスチャを試せる。
  three.ImageElement _checkerImage() {
    const size = 8;
    final data = Uint8List(size * size * 4);
    for (var y = 0; y < size; y++) {
      for (var x = 0; x < size; x++) {
        final i = (y * size + x) * 4;
        final on = ((x + y) & 1) == 0;
        final c = on ? 235 : 40;
        data[i] = c;
        data[i + 1] = c;
        data[i + 2] = c;
        data[i + 3] = 255;
      }
    }
    return three.ImageElement(width: size, height: size, data: data);
  }

  Future<void> _setup() async {
    threeJs.scene = three.Scene()
      ..background = three.Color.fromHex32(0x202028);

    threeJs.camera = three.PerspectiveCamera(
      45,
      threeJs.width / threeJs.height,
      0.1,
      1000,
    )..position.setValues(0, 60, 200);
    threeJs.camera.lookAt(three.Vector3(0, 0, 0));

    threeJs.scene.add(three.AmbientLight(0xffffff, 0.3));
    final dir = three.DirectionalLight(0xffffff, 1.0)
      ..position.setValues(80, 200, 120)
      ..castShadow = true;
    threeJs.scene.add(dir);

    final checker = three.CanvasTexture(_checkerImage())
      ..wrapS = three.RepeatWrapping
      ..wrapT = three.RepeatWrapping
      ..magFilter = three.NearestFilter
      ..repeat.setValues(4, 4);

    // 床にテクスチャを敷く
    final ground = three.Mesh(
      three.PlaneGeometry(400, 400),
      three.MeshStandardMaterial.fromMap({
        'map': checker,
        'roughness': 0.8,
      }),
    )
      ..rotation.x = -math.pi / 2
      ..receiveShadow = true;
    threeJs.scene.add(ground);

    // 各マテリアル比較用の球
    three.Mesh sphereWith(three.Material material, double x) {
      return three.Mesh(three.SphereGeometry(22, 32, 16), material)
        ..position.setValues(x, 25, 0)
        ..castShadow = true;
    }

    threeJs.scene.add(
      sphereWith(
        three.MeshBasicMaterial.fromMap({'map': checker}),
        -90,
      ),
    );
    threeJs.scene.add(
      sphereWith(
        three.MeshPhongMaterial.fromMap({
          'map': checker,
          'shininess': 60,
          'specular': 0xaaaaaa,
        }),
        -30,
      ),
    );
    threeJs.scene.add(
      sphereWith(
        three.MeshStandardMaterial.fromMap({
          'map': checker,
          'roughness': 0.3,
          'metalness': 0.0,
        }),
        30,
      ),
    );
    threeJs.scene.add(
      sphereWith(
        three.MeshStandardMaterial.fromMap({
          'color': 0xc0c0c0,
          'roughness': 0.2,
          'metalness': 1.0,
        }),
        90,
      ),
    );

    threeJs.addAnimationEvent((dt) {
      final t = DateTime.now().millisecondsSinceEpoch * 0.001;
      threeJs.scene.traverse((obj) {
        if (obj is three.Mesh && obj.geometry is three.SphereGeometry) {
          obj.rotation.y = t * 0.6;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('03. テクスチャ & マテリアル')),
      body: threeJs.build(),
    );
  }
}
