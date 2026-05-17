import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'future_provider_sample.g.dart';

// ---------------------------------------------------------------------------
// FutureProvider: 非同期で取得した値を扱う Provider。
//   - 戻り値が Future<T> なら自動的に AsyncValue<T> として購読できる。
//   - AsyncValue は data / loading / error の 3 状態を持ち、.when でハンドリングする。
//   - ref.invalidate(provider) で破棄 → 再生成 = 再フェッチができる。
// ---------------------------------------------------------------------------
@riverpod
Future<String> randomQuote(Ref ref) async {
  await Future.delayed(const Duration(seconds: 1));
  const quotes = [
    'Stay hungry, stay foolish.',
    'Simplicity is the ultimate sophistication.',
    'Talk is cheap. Show me the code.',
    'Premature optimization is the root of all evil.',
  ];
  return quotes[Random().nextInt(quotes.length)];
}

class FutureProviderSamplePage extends ConsumerWidget {
  const FutureProviderSamplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncQuote = ref.watch(randomQuoteProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('FutureProvider')),
      body: Center(
        child: asyncQuote.when(
          data: (quote) => Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              quote,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // invalidate: provider を破棄して次の watch 時に再生成 = 再フェッチさせる。
        onPressed: () => ref.invalidate(randomQuoteProvider),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
