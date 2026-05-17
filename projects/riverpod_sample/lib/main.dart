import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'samples/provider_sample.dart';
import 'samples/notifier_sample.dart';
import 'samples/future_provider_sample.dart';
import 'samples/stream_provider_sample.dart';
import 'samples/family_auto_dispose_sample.dart';
import 'samples/ref_listen_sample.dart';

void main() {
  // ProviderScope: アプリ全体で Provider の状態を保持するスコープ。
  // ルートに必ず 1 つ配置する。
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Samples',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const HomePage(),
    );
  }
}

class _SampleEntry {
  const _SampleEntry(this.title, this.subtitle, this.builder);
  final String title;
  final String subtitle;
  final WidgetBuilder builder;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static final _samples = <_SampleEntry>[
    _SampleEntry(
      '1. Provider',
      '不変の値を公開する基本形',
      (_) => const ProviderSamplePage(),
    ),
    _SampleEntry(
      '2. NotifierProvider',
      'mutable state と ref.watch / ref.read の使い分け',
      (_) => const NotifierSamplePage(),
    ),
    _SampleEntry(
      '3. FutureProvider',
      '非同期処理を AsyncValue で扱う',
      (_) => const FutureProviderSamplePage(),
    ),
    _SampleEntry(
      '4. StreamProvider',
      'Stream を購読する',
      (_) => const StreamProviderSamplePage(),
    ),
    _SampleEntry(
      '5. family / autoDispose',
      '引数付き Provider と自動破棄',
      (_) => const FamilyAutoDisposeSamplePage(),
    ),
    _SampleEntry(
      '6. ref.listen',
      '状態変化を副作用（SnackBar 等）にフックする',
      (_) => const RefListenSamplePage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod Samples')),
      body: ListView.separated(
        itemCount: _samples.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final sample = _samples[index];
          return ListTile(
            title: Text(sample.title),
            subtitle: Text(sample.subtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: sample.builder)),
          );
        },
      ),
    );
  }
}
