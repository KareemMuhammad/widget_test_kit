import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_test_kit/widget_test_kit.dart';

void main() {
  group('mockNetworkImages()', () {
    testWidgets('lets Image.network render without a real network request', (
      tester,
    ) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          const TestApp(
            child: Image(image: NetworkImage('https://example.com/avatar.png')),
          ),
        );

        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        tester.expectThat(find.byType(Image), matchers: [toBeVisible()]);
      });
    });
  });
}
