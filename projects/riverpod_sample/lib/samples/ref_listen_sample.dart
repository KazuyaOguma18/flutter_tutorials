import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ref_listen_sample.g.dart';

// ---------------------------------------------------------------------------
// ref.listen: 状態変化を検知して副作用（SnackBar、画面遷移、ログ等）を実行する。
//   - build 中に SnackBar を出すなどの副作用を直接書くのは NG。
//     listen は「state が変化した瞬間」だけコールバックが呼ばれるので、副作用の置き場として最適。
//   - コールバックには (previous, next) が渡る。「初めて閾値を超えた瞬間」のような判定もできる。
// ---------------------------------------------------------------------------
@riverpod
class Score extends _$Score {
  @override
  int build() => 0;

  void add(int delta) => state += delta;
}

class RefListenSamplePage extends ConsumerWidget {
  const RefListenSamplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // listen は build 時に登録するが、Widget の再 build はトリガーされない。
    ref.listen<int>(scoreProvider, (previous, next) {
      if ((previous ?? 0) < 10 && next >= 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('10 点に到達しました！')),
        );
      }
    });

    final score = ref.watch(scoreProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('ref.listen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$score', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => ref.read(scoreProvider.notifier).add(1),
              child: const Text('+1'),
            ),
          ],
        ),
      ),
    );
  }
}
