import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:three_js/three_js.dart' as three;

/// 04. コントロール & アニメーション (+ GLTFLoader)
///
///   - `OrbitControls` でマウス/タッチ操作。
///     ダンピング有効化のため毎フレーム `controls.update()` を呼ぶ。
///   - `addAnimationEvent` のコールバックで Mesh を時間で動かす。
///   - `GLTFLoader().fromAsset(...)` のコード例も併記。
///     実際にモデルを表示するには `assets/models/your_model.glb` を置き、
///     `pubspec.yaml` の assets に登録した上でコメントを外す。
class ControlsSamplePage extends StatefulWidget {
  const ControlsSamplePage({super.key});

  @override
  State<ControlsSamplePage> createState() => _ControlsSamplePageState();
}

class _ControlsSamplePageState extends State<ControlsSamplePage> {
  late final three.ThreeJS threeJs;
  three.OrbitControls? _controls;

  final List<three.Mesh> _planets = [];

  @override
  void initState() {
    super.initState();
    threeJs = three.ThreeJS(
      onSetupComplete: () => setState(() {}),
      setup: _setup,
    );
  }

  @override
  void dispose() {
    _controls?.dispose();
    threeJs.dispose();
    super.dispose();
  }

  Future<void> _setup() async {
    threeJs.scene = three.Scene()
      ..background = three.Color.fromHex32(0x101018)
      ..fog = three.FogExp2(0x101018, 0.0015);

    threeJs.camera = three.PerspectiveCamera(
      45,
      threeJs.width / threeJs.height,
      0.1,
      2000,
    )..position.setValues(180, 140, 260);

    _controls = three.OrbitControls(threeJs.camera, threeJs.globalKey)
      ..enableDamping = true
      ..dampingFactor = 0.08
      ..minDistance = 80
      ..maxDistance = 600
      ..maxPolarAngle = math.pi * 0.49;

    threeJs.scene.add(three.AmbientLight(0xffffff, 0.25));
    final sunLight = three.PointLight(0xffffff, 1.2, 0)
      ..position.setValues(0, 0, 0);
    threeJs.scene.add(sunLight);

    // 中心の太陽
    threeJs.scene.add(
      three.Mesh(
        three.SphereGeometry(20, 32, 16),
        three.MeshBasicMaterial.fromMap({'color': 0xffaa33}),
      ),
    );

    // 軌道上を回る惑星 (procedural アニメーション)
    final rng = math.Random(1);
    for (var i = 0; i < 6; i++) {
      final radius = 50.0 + i * 30;
      final size = 4.0 + rng.nextDouble() * 8;
      final color = 0x224488 +
          rng.nextInt(0x66) * 0x010000 +
          rng.nextInt(0x66) * 0x000100 +
          rng.nextInt(0x66);

      final mesh = three.Mesh(
        three.SphereGeometry(size, 24, 12),
        three.MeshStandardMaterial.fromMap({
          'color': color,
          'roughness': 0.7,
        }),
      );
      // 位置と速度は userData に格納し、アニメーションで参照する
      mesh.userData = {
        'radius': radius,
        'speed': 0.6 - i * 0.07,
        'phase': rng.nextDouble() * math.pi * 2,
      };
      _planets.add(mesh);
      threeJs.scene.add(mesh);
    }

    // 床 (グリッド代わりの薄い円盤)
    threeJs.scene.add(
      three.Mesh(
        three.CircleGeometry(radius: 400, segments: 64),
        three.MeshBasicMaterial.fromMap({
          'color': 0x202028,
          'transparent': true,
          'opacity': 0.6,
        }),
      )
        ..rotation.x = -math.pi / 2
        ..position.y = -40,
    );

    // ----- GLTF を読み込みたい場合の例 -----
    // pubspec.yaml に assets: - assets/models/foo.glb を追加し、以下を有効化。
    //
    // final loader = three.GLTFLoader(flipY: true);
    // final gltf = await loader.fromAsset('assets/models/foo.glb');
    // if (gltf != null) {
    //   threeJs.scene.add(gltf.scene);
    //   if (gltf.animations != null && gltf.animations!.isNotEmpty) {
    //     final mixer = three.AnimationMixer(gltf.scene);
    //     mixer.clipAction(gltf.animations!.first)?.play();
    //     threeJs.addAnimationEvent(mixer.update);
    //   }
    // }

    threeJs.addAnimationEvent((dt) {
      _controls?.update();
      final t = DateTime.now().millisecondsSinceEpoch * 0.001;
      for (final p in _planets) {
        final ud = p.userData;
        final r = ud['radius'] as double;
        final s = ud['speed'] as double;
        final phase = ud['phase'] as double;
        p.position.x = math.cos(t * s + phase) * r;
        p.position.z = math.sin(t * s + phase) * r;
        p.rotation.y = t * 1.2;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('04. コントロール & アニメーション')),
      body: threeJs.build(),
    );
  }
}
