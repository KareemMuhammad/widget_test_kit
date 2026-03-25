import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_test_helper/widget_test_helper.dart';

void main() {
  group('completeForm', () {
    testWidgets('fills multiple fields by Key', (tester) async {
      await tester.pumpWidget(const TestApp(child: _SimpleForm()));

      await tester.completeForm({
        'email': 'user@example.com',
        'password': 'secret123',
      });

      tester.expectThat(
        find.byKey(const Key('email')),
        matchers: [toHaveValue('user@example.com')],
      );
      tester.expectThat(
        find.byKey(const Key('password')),
        matchers: [toHaveValue('secret123')],
      );
    });

    testWidgets('uses custom findField strategy', (tester) async {
      await tester.pumpWidget(const TestApp(child: _SimpleForm()));

      await tester.completeForm(
        {'Email': 'a@b.com'},
        findField: (key) => find.widgetWithText(TextFormField, key),
      );

      tester.expectThat(
        find.byKey(const Key('email')),
        matchers: [toHaveValue('a@b.com')],
      );
    });
  });

  group('updateField', () {
    testWidgets('clears existing text and enters new value', (tester) async {
      await tester.pumpWidget(const TestApp(child: _SimpleForm()));

      // First fill.
      await tester.completeForm({'email': 'old@example.com'});

      // Update.
      await tester.updateField('email', 'new@example.com');

      tester.expectThat(
        find.byKey(const Key('email')),
        matchers: [toHaveValue('new@example.com')],
      );
    });
  });

  group('updateForm', () {
    testWidgets('updates multiple fields', (tester) async {
      await tester.pumpWidget(const TestApp(child: _SimpleForm()));

      await tester.completeForm({
        'email': 'old@example.com',
        'password': 'oldpass',
      });

      await tester.updateForm({
        'email': 'new@example.com',
        'password': 'newpass',
      });

      tester.expectThat(
        find.byKey(const Key('email')),
        matchers: [toHaveValue('new@example.com')],
      );
      tester.expectThat(
        find.byKey(const Key('password')),
        matchers: [toHaveValue('newpass')],
      );
    });
  });

  group('submitForm', () {
    testWidgets('taps the submit button', (tester) async {
      var submitted = false;

      await tester.pumpWidget(
        TestApp(
          child: ElevatedButton(
            key: const Key('submit'),
            onPressed: () => submitted = true,
            child: const Text('Submit'),
          ),
        ),
      );

      await tester.submitForm(find.button('Submit'));
      expect(submitted, isTrue);
    });
  });

  group('clearForm', () {
    testWidgets('empties all listed fields', (tester) async {
      await tester.pumpWidget(const TestApp(child: _SimpleForm()));

      await tester.completeForm({
        'email': 'user@example.com',
        'password': 'secret',
      });

      await tester.clearForm(['email', 'password']);

      tester.expectThat(
        find.byKey(const Key('email')),
        matchers: [toHaveValue('')],
      );
      tester.expectThat(
        find.byKey(const Key('password')),
        matchers: [toHaveValue('')],
      );
    });
  });
}

/// A minimal form with two [TextFormField]s, keyed `email` and `password`.
class _SimpleForm extends StatelessWidget {
  const _SimpleForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          key: const Key('email'),
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        TextFormField(
          key: const Key('password'),
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
      ],
    );
  }
}

