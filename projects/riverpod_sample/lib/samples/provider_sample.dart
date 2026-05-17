import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider_sample.g.dart';

// ---------------------------------------------------------------------------
// Provider: 不変（immutable）の値を公開するもっとも基本的な Provider。
//   - 値は build 時に一度だけ評価され、変わらない。
//   - 設定値・計算結果・依存性注入などに使う。
//   - @riverpod のデフォルトは autoDispose（参照する Widget が無くなれば破棄）。
//     keepAlive: true で常駐させられる。
// ---------------------------------------------------------------------------
@Riverpod(keepAlive: true)
String greeting(Ref ref) => 'Hello, Riverpod!';

class ProviderSamplePage extends ConsumerWidget {
  const ProviderSamplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch: provider の値を購読する。値が変わるとこの Widget が再 build される。
    final value = ref.watch(greetingProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Provider')),
      body: Center(
        child: Text(value, style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}
