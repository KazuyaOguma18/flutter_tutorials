import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:three_js/three_js.dart' as three;

/// 02. ライティング & 影
///
///   - `AmbientLight` 全体光
///   - `DirectionalLight` 平行光 (太陽光のような無限遠光源)
///   - `PointLight` 点光源 (回転させて影が動くのを確認)
///   - `SpotLight` スポットライト
///   - 影は `Settings.enableShadowMap` + 各オブジェクトの `castShadow` /
///     `receiveShadow` + ライトの `castShadow` で有効化する。
class LightingSamplePage extends StatefulWidget {
  const LightingSamplePage({super.key});

  @override
  State<LightingSamplePage> createState() => _LightingSamplePageState();
}

class _LightingSamplePageState extends State<LightingSamplePage> {
  late final three.ThreeJS threeJs;
  late three.PointLight _pointLight;
  late three.SpotLight _spotLight;

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

  Future<void> _setup() async {
    threeJs.scene = three.Scene()
      ..background = three.Color.fromHex32(0x101018);

    threeJs.camera = three.PerspectiveCamera(
      45,
      threeJs.width / threeJs.height,
      0.1,
      2000,
    )..position.setValues(120, 120, 220);
    threeJs.camera.lookAt(three.Vector3(0, 20, 0));

    // 1. 全体の底上げ
    threeJs.scene.add(three.AmbientLight(0xffffff, 0.15));

    // 2. 平行光 (キーライト) + 影
    final dir = three.DirectionalLight(0xffffff, 0.6)
      ..position.setValues(80, 200, 100)
      ..castShadow = true;
    dir.shadow!.mapSize.width = 1024;
    dir.shadow!.mapSize.height = 1024;
    dir.shadow!.camera!.near = 1;
    dir.shadow!.camera!.far = 500;
    dir.shadow!.camera!.left = -200;
    dir.shadow!.camera!.right = 200;
    dir.shadow!.camera!.top = 200;
    dir.shadow!.camera!.bottom = -200;
    threeJs.scene.add(dir);

    // 3. 点光源 (アニメーションで動かす)
    _pointLight = three.PointLight(0xff7755, 1.5, 400)
      ..position.setValues(0, 80, 0)
      ..castShadow = true;
    threeJs.scene.add(_pointLight);

    // 4. スポットライト
    _spotLight = three.SpotLight(0x66ccff, 2.0)
      ..position.setValues(-150, 200, 150)
      ..angle = math.pi / 8
      ..penumbra = 0.3
      ..decay = 1.0
      ..distance = 600
      ..castShadow = true;
    final spotTarget = three.Object3D()..position.setValues(0, 0, 0);
    _spotLight.target = spotTarget;
    threeJs.scene
      ..add(_spotLight)
      ..add(spotTarget);

    // 床: receiveShadow
    final ground = three.Mesh(
      three.PlaneGeometry(600, 600),
      three.MeshStandardMaterial.fromMap({
        'color': 0x555560,
        'roughness': 0.9,
      }),
    )
      ..rotation.x = -math.pi / 2
      ..receiveShadow = true;
    threeJs.scene.add(ground);

    // 影を落とすオブジェクト群
    final rng = math.Random(42);
    for (var i = 0; i < 12; i++) {
      final mesh = three.Mesh(
        three.BoxGeometry(20, 20 + rng.nextDouble() * 30, 20),
        three.MeshStandardMaterial.fromMap({
          'color': 0xaaaadd,
          'roughness': 0.6,
        }),
      );
      mesh.position.setValues(
        (rng.nextDouble() - 0.5) * 240,
        20,
        (rng.nextDouble() - 0.5) * 240,
      );
      mesh.castShadow = true;
      mesh.receiveShadow = true;
      threeJs.scene.add(mesh);
    }

    threeJs.addAnimationEvent((dt) {
      final t = DateTime.now().millisecondsSinceEpoch * 0.001;
      _pointLight.position.x = math.cos(t) * 120;
      _pointLight.position.z = math.sin(t) * 120;
      _pointLight.position.y = 60 + math.sin(t * 2) * 20;

      _spotLight.position.x = math.cos(t * 0.5) * 180;
      _spotLight.position.z = math.sin(t * 0.5) * 180;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('02. ライティング & 影')),
      body: threeJs.build(),
    );
  }
}
