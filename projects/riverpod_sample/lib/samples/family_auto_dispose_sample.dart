import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'family_auto_dispose_sample.g.dart';

// ---------------------------------------------------------------------------
// family / autoDispose:
//   - family: provider に引数を渡せる。引数の値ごとに別インスタンスが作られる。
//     例: userNameProvider(1), userNameProvider(2) はそれぞれ独立。
//   - autoDispose: @riverpod のデフォルト。watch している Widget が居なくなったら破棄される。
//     画面を離れて戻ってきたら再フェッチされる、と覚えればよい。
//     keepAlive: true を付けると破棄されない（前述の Provider サンプル参照）。
// ---------------------------------------------------------------------------
@riverpod
Future<String> userName(Ref ref, int userId) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return 'User #$userId';
}

class FamilyAutoDisposeSamplePage extends ConsumerWidget {
  const FamilyAutoDisposeSamplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('family / autoDispose')),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          final userId = index + 1;
          // family: 引数を渡して provider を取得する。
          final asyncName = ref.watch(userNameProvider(userId));
          return ListTile(
            leading: CircleAvatar(child: Text('$userId')),
            title: asyncName.when(
              data: (name) => Text(name),
              loading: () => const Text('Loading...'),
              error: (error, stack) => Text('Error: $error'),
            ),
          );
        },
      ),
    );
  }
}
