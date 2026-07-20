import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_test_kit/widget_test_kit.dart';

void main() {
  group('toHaveItemCount()', () {
    testWidgets('passes for ListView with explicit children', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: ListView(children: [Text('One'), Text('Two'), Text('Three')]),
        ),
      );

      tester.expectThat(find.byType(ListView), matchers: [toHaveItemCount(3)]);
    });

    testWidgets('passes for GridView with itemCount', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: 4,
            itemBuilder: (_, index) => Text('Item $index'),
          ),
        ),
      );

      tester.expectThat(find.byType(GridView), matchers: [toHaveItemCount(4)]);
    });

    testWidgets('fails clearly when builder itemCount is omitted', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: ListView.builder(
            itemBuilder: (_, index) => Text('Item $index'),
          ),
        ),
      );

      expect(
        () => tester.expectThat(
          find.byType(ListView),
          matchers: [toHaveItemCount(1)],
        ),
        throwsA(
          isA<TestFailure>().having(
            (failure) => failure.message,
            'message',
            contains('must provide itemCount'),
          ),
        ),
      );
    });
  });

  group('toContainWidget()', () {
    testWidgets('passes when descendant finder matches', (tester) async {
      await tester.pumpWidget(
        TestApp(child: ListView(children: const [Text('Item 1')])),
      );

      tester.expectThat(
        find.byType(ListView),
        matchers: [toContainWidget(find.text('Item 1'))],
      );
    });
  });

  group('toBeScrollable()', () {
    testWidgets('passes for ListView', (tester) async {
      await tester.pumpWidget(
        TestApp(child: ListView(children: const [Text('Item')])),
      );

      tester.expectThat(find.byType(ListView), matchers: [toBeScrollable()]);
    });
  });

  group('toBeEmptyList()', () {
    testWidgets('passes for empty ListView', (tester) async {
      await tester.pumpWidget(TestApp(child: ListView(children: const [])));

      tester.expectThat(find.byType(ListView), matchers: [toBeEmptyList()]);
    });

    testWidgets('fails for non-list widgets', (tester) async {
      await tester.pumpWidget(const TestApp(child: Column()));

      expect(
        () =>
            tester.expectThat(find.byType(Column), matchers: [toBeEmptyList()]),
        throwsA(isA<TestFailure>()),
      );
    });
  });
}
