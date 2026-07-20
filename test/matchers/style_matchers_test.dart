import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_test_kit/widget_test_kit.dart';

void main() {
  group('style matchers', () {
    testWidgets('toHaveOpacity matches Opacity widget', (tester) async {
      await tester.pumpWidget(
        const TestApp(child: Opacity(opacity: 0.5, child: Text('Fade'))),
      );

      tester.expectThat(find.byType(Opacity), matchers: [toHaveOpacity(0.5)]);
    });

    testWidgets('toHaveColor matches Icon color', (tester) async {
      await tester.pumpWidget(
        const TestApp(child: Icon(Icons.add, color: Colors.red)),
      );

      tester.expectThat(
        find.byIcon(Icons.add),
        matchers: [toHaveColor(Colors.red)],
      );
    });

    testWidgets('toHaveFontSize matches Text style', (tester) async {
      await tester.pumpWidget(
        const TestApp(child: Text('Title', style: TextStyle(fontSize: 24))),
      );

      tester.expectThat(find.text('Title'), matchers: [toHaveFontSize(24)]);
    });

    testWidgets('toHavePadding matches Padding widget', (tester) async {
      await tester.pumpWidget(
        const TestApp(
          child: Padding(padding: EdgeInsets.all(16), child: Text('Padded')),
        ),
      );

      tester.expectThat(
        find.byType(Padding),
        matchers: [toHavePadding(const EdgeInsets.all(16))],
      );
    });

    testWidgets('toHaveDecoration matches Container decoration', (
      tester,
    ) async {
      const decoration = BoxDecoration(color: Colors.blue);

      await tester.pumpWidget(
        TestApp(
          child: Container(decoration: decoration, child: Text('Box')),
        ),
      );

      tester.expectThat(
        find.byType(Container),
        matchers: [toHaveDecoration(decoration)],
      );
    });

    testWidgets('toHaveBorderRadius matches ClipRRect radius', (tester) async {
      final radius = BorderRadius.circular(8);

      await tester.pumpWidget(
        TestApp(
          child: ClipRRect(
            borderRadius: radius,
            child: const SizedBox(width: 20, height: 20),
          ),
        ),
      );

      tester.expectThat(
        find.byType(ClipRRect),
        matchers: [toHaveBorderRadius(radius)],
      );
    });

    testWidgets('toHaveAlignment matches Align alignment', (tester) async {
      await tester.pumpWidget(
        const TestApp(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Text('Aligned'),
          ),
        ),
      );

      tester.expectThat(
        find.byType(Align),
        matchers: [toHaveAlignment(Alignment.bottomRight)],
      );
    });

    testWidgets('toHaveElevation matches Card elevation', (tester) async {
      await tester.pumpWidget(
        const TestApp(child: Card(elevation: 6, child: Text('Card'))),
      );

      tester.expectThat(find.byType(Card), matchers: [toHaveElevation(6)]);
    });

    testWidgets('toHaveBoxShadow matches DecoratedBox boxShadow', (
      tester,
    ) async {
      const shadow = [BoxShadow(blurRadius: 4)];

      await tester.pumpWidget(
        const TestApp(
          child: DecoratedBox(
            decoration: BoxDecoration(boxShadow: shadow),
            child: SizedBox(width: 20, height: 20),
          ),
        ),
      );

      tester.expectThat(
        find.byType(DecoratedBox),
        matchers: [toHaveBoxShadow(shadow)],
      );
    });

    testWidgets('toHaveGradient matches Container gradient', (tester) async {
      const gradient = LinearGradient(colors: [Colors.red, Colors.blue]);

      await tester.pumpWidget(
        TestApp(
          child: Container(
            decoration: const BoxDecoration(gradient: gradient),
            child: const SizedBox(width: 20, height: 20),
          ),
        ),
      );

      tester.expectThat(
        find.byType(Container),
        matchers: [toHaveGradient(gradient)],
      );
    });

    testWidgets('toHaveTextAlign matches Text alignment', (tester) async {
      await tester.pumpWidget(
        const TestApp(child: Text('Centered', textAlign: TextAlign.center)),
      );

      tester.expectThat(
        find.text('Centered'),
        matchers: [toHaveTextAlign(TextAlign.center)],
      );
    });

    testWidgets('toHaveFontWeight matches Text style', (tester) async {
      await tester.pumpWidget(
        const TestApp(
          child: Text('Bold', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      );

      tester.expectThat(
        find.text('Bold'),
        matchers: [toHaveFontWeight(FontWeight.bold)],
      );
    });

    testWidgets('toHaveMaxLines matches Text maxLines', (tester) async {
      await tester.pumpWidget(
        const TestApp(child: Text('Two lines max', maxLines: 2)),
      );

      tester.expectThat(
        find.text('Two lines max'),
        matchers: [toHaveMaxLines(2)],
      );
    });

    testWidgets('unsupported widgets fail clearly', (tester) async {
      await tester.pumpWidget(const TestApp(child: SizedBox()));

      expect(
        () => tester.expectThat(
          find.byType(SizedBox),
          matchers: [toHaveColor(Colors.red)],
        ),
        throwsA(isA<TestFailure>()),
      );
    });
  });
}
