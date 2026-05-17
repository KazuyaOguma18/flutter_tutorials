import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:riverpod_sample/main.dart';

void main() {
  testWidgets('Home page lists all samples', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(find.text('Riverpod Samples'), findsOneWidget);
    expect(find.text('1. Provider'), findsOneWidget);
    expect(find.text('6. ref.listen'), findsOneWidget);
  });
}
