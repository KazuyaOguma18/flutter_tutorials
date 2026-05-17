import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:threejs_sample/main.dart';

void main() {
  testWidgets('sample menu renders all entries', (tester) async {
    await tester.pumpWidget(const ThreeJsSampleApp());

    expect(find.byType(ListTile), findsNWidgets(4));
    expect(find.textContaining('01.'), findsOneWidget);
    expect(find.textContaining('04.'), findsOneWidget);
  });
}
