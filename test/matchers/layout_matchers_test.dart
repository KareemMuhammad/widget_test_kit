
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_test_kit/widget_test_kit.dart';

void main() {
  // ---------------------------------------------------------------------------
  // toHaveSize
  // ---------------------------------------------------------------------------
  group('toHaveSize()', () {
    testWidgets('passes when size matches', (tester) async {
      await tester.pumpWidget(
        const TestApp(
          child: SizedBox(
            key: Key('box'),
            width: 100,
            height: 50,
          ),
        ),
      );

      tester.expectThat(
        find.byKey(const Key('box')),
        matchers: [toHaveSize(const Size(100, 50))],
      );
    });

    testWidgets('fails when size does not match', (tester) async {
      await tester.pumpWidget(
        const TestApp(
          child: SizedBox(key: Key('box'), width: 100, height: 50),
        ),
      );

      expect(
        () => tester.expectThat(
          find.byKey(const Key('box')),
          matchers: [toHaveSize(const Size(200, 50))],
        ),
        throwsA(isA<TestFailure>()),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // toBePositioned
  // ---------------------------------------------------------------------------
  group('toBePositioned()', () {
    testWidgets('passes when position matches', (tester) async {
      await tester.pumpWidget(
        const TestApp(
          child: Stack(
            children: [
              Positioned(
                left: 10,
                top: 20,
                child: SizedBox(key: Key('pos'), width: 30, height: 30),
              ),
            ],
          ),
        ),
      );

      // Scaffold body is at some offset; Positioned is relative to Stack.
      final topLeft = tester.getTopLeft(find.byKey(const Key('pos')));

      tester.expectThat(
        find.byKey(const Key('pos')),
        matchers: [toBePositioned(topLeft.dx, topLeft.dy)],
      );
    });
  });

  // ---------------------------------------------------------------------------
  // toBeWithin
  // ---------------------------------------------------------------------------
  group('toBeWithin()', () {
    testWidgets('passes when widget is inside parent', (tester) async {
      await tester.pumpWidget(
        const TestApp(
          child: Card(
            key: Key('card'),
            child: Text('Inside'),
          ),
        ),
      );

      tester.expectThat(
        find.text('Inside'),
        matchers: [toBeWithin(find.byKey(const Key('card')))],
      );
    });

    testWidgets('fails when widget is not inside parent', (tester) async {
      await tester.pumpWidget(
        const TestApp(
          child: Column(
            children: [
              Card(key: Key('card'), child: Text('A')),
              Text('Outside'),
            ],
          ),
        ),
      );

      expect(
        () => tester.expectThat(
          find.text('Outside'),
          matchers: [toBeWithin(find.byKey(const Key('card')))],
        ),
        throwsA(isA<TestFailure>()),
      );
    });
  });
}

