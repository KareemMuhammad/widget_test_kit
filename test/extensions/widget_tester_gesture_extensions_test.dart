import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_test_kit/widget_test_kit.dart';

void main() {
  group('tap variants', () {
    testWidgets('longPressOn triggers long press callback', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        TestApp(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onLongPress: () => pressed = true,
            child: const SizedBox(width: 80, height: 80),
          ),
        ),
      );

      await tester.longPressOn(find.byType(GestureDetector));

      expect(pressed, isTrue);
    });

    testWidgets('doubleTapOn triggers double tap callback', (tester) async {
      var doubleTapped = false;

      await tester.pumpWidget(
        TestApp(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onDoubleTap: () => doubleTapped = true,
            child: const SizedBox(width: 80, height: 80),
          ),
        ),
      );

      await tester.doubleTapOn(find.byType(GestureDetector));

      expect(doubleTapped, isTrue);
    });
  });

  group('slider helpers', () {
    testWidgets('dragSliderTo changes Slider value', (tester) async {
      double value = 0;

      await tester.pumpWidget(
        TestApp(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Slider(
                value: value,
                onChanged: (next) => setState(() => value = next),
              );
            },
          ),
        ),
      );

      await tester.dragSliderTo(find.byType(Slider), 1);

      expect(value, greaterThan(0.8));
    });
  });

  group('scroll helpers', () {
    testWidgets('scrollUntilFound scrolls until target appears', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: SizedBox(
            height: 200,
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  50,
                  (index) => SizedBox(height: 48, child: Text('Item $index')),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.scrollUntilFound(find.text('Item 30'), delta: 400);

      expect(find.text('Item 30'), findsOneWidget);
    });
  });

  group('swipe helpers', () {
    testWidgets('swipeLeft dismisses Dismissible', (tester) async {
      var dismissed = false;

      await tester.pumpWidget(
        TestApp(
          child: Dismissible(
            key: const Key('dismissible'),
            onDismissed: (_) => dismissed = true,
            child: const SizedBox(width: 200, height: 80),
          ),
        ),
      );

      await tester.swipeLeft(find.byKey(const Key('dismissible')));

      expect(dismissed, isTrue);
    });
  });

  group('pullToRefresh()', () {
    testWidgets('triggers RefreshIndicator callback', (tester) async {
      var refreshed = false;

      await tester.pumpWidget(
        TestApp(
          child: RefreshIndicator(
            onRefresh: () async {
              refreshed = true;
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [SizedBox(height: 600, child: Text('Content'))],
            ),
          ),
        ),
      );

      await tester.pullToRefresh(find.byType(RefreshIndicator));

      expect(refreshed, isTrue);
    });
  });
}
