import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifier_sample.g.dart';

// ---------------------------------------------------------------------------
// NotifierProvider: mutable な状態を持つ Provider。
//   - build() で初期値を返す。
//   - メソッドで state を変更すると、watch している Widget が再 build される。
//   - ref.watch vs ref.read の使い分けがポイント。
//       watch: 値の変化を購読したい場所（build 内、Text に表示する値など）
//       read : 値を一度だけ取り出したい場所（ボタンの onPressed など、副作用の起点）
// ---------------------------------------------------------------------------
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
}

class NotifierSamplePage extends ConsumerWidget {
  const NotifierSamplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 表示する値は watch（変化を追いたい）。
    final count = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('NotifierProvider')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$count', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // onPressed の中は build ではないので read を使う。
                // .notifier を付けると Notifier インスタンス（メソッド呼び出し用）が取れる。
                ElevatedButton(
                  onPressed: () =>
                      ref.read(counterProvider.notifier).decrement(),
                  child: const Text('-'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () => ref.read(counterProvider.notifier).reset(),
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () =>
                      ref.read(counterProvider.notifier).increment(),
                  child: const Text('+'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
