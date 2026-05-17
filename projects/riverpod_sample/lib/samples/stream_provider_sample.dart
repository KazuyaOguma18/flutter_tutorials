import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stream_provider_sample.g.dart';

// ---------------------------------------------------------------------------
// StreamProvider: Stream を購読する Provider。
//   - 戻り値が Stream<T> なら AsyncValue<T> として購読できる（FutureProvider と同じ）。
//   - 接続維持系（WebSocket、Firestore、タイマー）に向く。
// ---------------------------------------------------------------------------
@riverpod
Stream<int> ticker(Ref ref) {
  return Stream.periodic(const Duration(seconds: 1), (count) => count + 1);
}

class StreamProviderSamplePage extends ConsumerWidget {
  const StreamProviderSamplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTick = ref.watch(tickerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('StreamProvider')),
      body: Center(
        child: asyncTick.when(
          data: (tick) =>
              Text('$tick', style: Theme.of(context).textTheme.displayLarge),
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
        ),
      ),
    );
  }
}
