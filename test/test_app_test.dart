import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_test_kit/widget_test_kit.dart';

void main() {
  group('TestApp', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(const TestApp(child: Text('Hello, World!')));

      expect(find.text('Hello, World!'), findsOneWidget);
    });

    testWidgets('wraps child in Scaffold', (tester) async {
      await tester.pumpWidget(const TestApp(child: Text('Scaffold check')));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('wraps child in MaterialApp', (tester) async {
      await tester.pumpWidget(const TestApp(child: Text('App check')));

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('applies custom theme', (tester) async {
      final theme = ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      );

      late ThemeData capturedTheme;

      await tester.pumpWidget(
        TestApp(
          theme: theme,
          child: Builder(
            builder: (context) {
              capturedTheme = Theme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedTheme.colorScheme.seed, theme.colorScheme.seed);
    });

    testWidgets('applies custom locale', (tester) async {
      await tester.pumpWidget(
        const TestApp(locale: Locale('en', 'US'), child: SizedBox()),
      );

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.locale, const Locale('en', 'US'));
    });

    testWidgets('hides debug banner', (tester) async {
      await tester.pumpWidget(const TestApp(child: SizedBox()));

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.debugShowCheckedModeBanner, isFalse);
    });
  });
}

// Tiny helper so the test reads nicely even when the colorScheme constructor
// doesn't expose the seed directly — we compare the primary colour instead.
extension on ColorScheme {
  Color get seed => primary;
}
