import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_test_kit/widget_test_kit.dart';

void main() {
  group('FieldFinders', () {
    testWidgets('byKey finds widget with matching Key', (tester) async {
      await tester.pumpWidget(
        const TestApp(child: TextField(key: Key('username'))),
      );

      expect(FieldFinders.byKey('username'), findsOneWidget);
    });

    testWidgets('byLabel finds TextFormField containing label text', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
          ),
        ),
      );

      expect(FieldFinders.byLabel('Email'), findsOneWidget);
    });

    testWidgets('byHint finds TextField with matching hintText', (
      tester,
    ) async {
      await tester.pumpWidget(
        const TestApp(
          child: TextField(
            decoration: InputDecoration(hintText: 'Enter email'),
          ),
        ),
      );

      expect(FieldFinders.byHint('Enter email'), findsOneWidget);
    });

    testWidgets('bySemantics finds widget by semantics label', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        TestApp(
          child: Semantics(
            label: 'close button',
            child: IconButton(icon: const Icon(Icons.close), onPressed: () {}),
          ),
        ),
      );

      expect(FieldFinders.bySemantics('close button'), findsOneWidget);

      handle.dispose();
    });
  });
}
