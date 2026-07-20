import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_test_kit/widget_test_kit.dart';

void main() {
  group('navigation extensions', () {
    testWidgets('navigateTo pushes a named route and goBack pops it', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          routes: {'/settings': (_) => const Scaffold(body: Text('Settings'))},
          child: const Text('Home'),
        ),
      );

      tester.expectRoute('/');

      await tester.navigateTo('/settings');
      tester.expectRoute('/settings');
      expect(find.text('Settings'), findsOneWidget);

      await tester.goBack();
      tester.expectRoute('/');
      expect(find.text('Home'), findsOneWidget);
    });
  });

  group('overlay assertions', () {
    testWidgets('expectDialog and dismissDialog work with AlertDialog', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: Builder(
            builder: (context) {
              return TextButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (_) => const AlertDialog(content: Text('Dialog')),
                  );
                },
                child: const Text('Open'),
              );
            },
          ),
        ),
      );

      tester.expectNoDialog();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      tester.expectDialog();

      await tester.dismissDialog();

      tester.expectNoDialog();
    });

    testWidgets('expectBottomSheet finds visible bottom sheet', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Builder(
            builder: (context) {
              return TextButton(
                onPressed: () {
                  Scaffold.of(context).showBottomSheet(
                    (_) => const SizedBox(height: 80, child: Text('Sheet')),
                  );
                },
                child: const Text('Show sheet'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show sheet'));
      await tester.pumpAndSettle();

      tester.expectBottomSheet();
      expect(find.text('Sheet'), findsOneWidget);
    });

    testWidgets('expectSnackBar finds snackbar and optional text', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: Builder(
            builder: (context) {
              return TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Saved!')));
                },
                child: const Text('Save'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Save'));
      await tester.pump();

      tester.expectSnackBar(withText: 'Saved!');
    });
  });
}
