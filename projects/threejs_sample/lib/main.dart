import 'package:flutter/material.dart';

import 'samples/basics_sample.dart';
import 'samples/controls_sample.dart';
import 'samples/lighting_sample.dart';
import 'samples/texture_sample.dart';

void main() {
  runApp(const ThreeJsSampleApp());
}

class ThreeJsSampleApp extends StatelessWidget {
  const ThreeJsSampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'three_js sample',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const SampleMenuPage(),
    );
  }
}

class _SampleEntry {
  const _SampleEntry({
    required this.title,
    required this.description,
    required this.builder,
  });

  final String title;
  final String description;
  final WidgetBuilder builder;
}

class SampleMenuPage extends StatelessWidget {
  const SampleMenuPage({super.key});

  static final _samples = <_SampleEntry>[
    _SampleEntry(
      title: '01. 基礎: Scene / Camera / Geometry / Material',
      description: '回転する立方体・球・平面で最小構成を確認する',
      builder: (_) => const BasicsSamplePage(),
    ),
    _SampleEntry(
      title: '02. ライティング & 影',
      description: 'Ambient / Directional / Point / Spot とシャドウマップ',
      builder: (_) => const LightingSamplePage(),
    ),
    _SampleEntry(
      title: '03. テクスチャ & マテリアル拡張',
      description: 'CanvasTexture / MeshStandardMaterial / PBR パラメータ',
      builder: (_) => const TextureSamplePage(),
    ),
    _SampleEntry(
      title: '04. コントロール & アニメーション',
      description: 'OrbitControls + AnimationMixer + GLTFLoader 呼び出し例',
      builder: (_) => const ControlsSamplePage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('three_js sample')),
      body: ListView.separated(
        itemCount: _samples.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final entry = _samples[index];
          return ListTile(
            title: Text(entry.title),
            subtitle: Text(entry.description),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: entry.builder),
              );
            },
          );
        },
      ),
    );
  }
}
