import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:three_js/three_js.dart' as three;

/// 01. 基礎: Scene / Camera / Renderer / Geometry / Material
///
/// Three.js の最小構成。
///   - `Scene` にオブジェクトを並べる
///   - `PerspectiveCamera` で投影
///   - `BoxGeometry` `SphereGeometry` `PlaneGeometry` + `MeshPhongMaterial`
///   - `addAnimationEvent` のコールバック内で各 Mesh を回転させる
class BasicsSamplePage extends StatefulWidget {
  const BasicsSamplePage({super.key});

  @override
  State<BasicsSamplePage> createState() => _BasicsSamplePageState();
}

class _BasicsSamplePageState extends State<BasicsSamplePage> {
  late final three.ThreeJS threeJs;

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
    threeJs.dispose();
    super.dispose();
  }

  Future<void> _setup() async {
    threeJs.scene = three.Scene()
      ..background = three.Color.fromHex32(0x202028);

    threeJs.camera = three.PerspectiveCamera(
      45,
      threeJs.width / threeJs.height,
      0.1,
      1000,
    )..position.setValues(0, 60, 220);
    threeJs.camera.lookAt(three.Vector3(0, 0, 0));

    threeJs.scene.add(three.AmbientLight(0xffffff, 0.4));
    final keyLight = three.DirectionalLight(0xffffff, 1.0)
      ..position.setValues(120, 200, 150);
    threeJs.scene.add(keyLight);

    final material = three.MeshPhongMaterial.fromMap({
      'color': 0x5599ff,
      'shininess': 60,
    });

    final box = three.Mesh(three.BoxGeometry(60, 60, 60), material)
      ..position.setValues(-90, 0, 0);
    final sphere = three.Mesh(three.SphereGeometry(38, 32, 16), material)
      ..position.setValues(0, 0, 0);
    final plane = three.Mesh(three.PlaneGeometry(80, 80, 4, 4), material)
      ..position.setValues(90, 0, 0);

    threeJs.scene
      ..add(box)
      ..add(sphere)
      ..add(plane);

    threeJs.addAnimationEvent((dt) {
      final t = DateTime.now().millisecondsSinceEpoch * 0.001;
      threeJs.scene.traverse((obj) {
        if (obj is three.Mesh) {
          obj.rotation.x = t * 0.7;
          obj.rotation.y = math.sin(t) * 0.8;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('01. 基礎')),
      body: threeJs.build(),
    );
  }
}
