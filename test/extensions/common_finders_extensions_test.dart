import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_test_kit/widget_test_kit.dart';

void main() {
  group('find.button()', () {
    testWidgets('finds ElevatedButton by label', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: ElevatedButton(onPressed: () {}, child: const Text('Go')),
        ),
      );

      expect(find.button('Go'), findsOneWidget);
    });

    testWidgets('finds TextButton by label', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: TextButton(onPressed: () {}, child: const Text('Cancel')),
        ),
      );

      expect(find.button('Cancel'), findsOneWidget);
    });

    testWidgets('finds OutlinedButton by label', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: OutlinedButton(onPressed: () {}, child: const Text('Details')),
        ),
      );

      expect(find.button('Details'), findsOneWidget);
    });

    testWidgets('finds FilledButton by label', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: FilledButton(onPressed: () {}, child: const Text('Save')),
        ),
      );

      expect(find.button('Save'), findsOneWidget);
    });

    testWidgets('returns findsNothing when no button matches', (tester) async {
      await tester.pumpWidget(const TestApp(child: Text('Not a button')));

      expect(find.button('Not a button'), findsNothing);
    });
  });

  group('find.iconWidget()', () {
    testWidgets('finds Icon by IconData', (tester) async {
      await tester.pumpWidget(const TestApp(child: Icon(Icons.favorite)));

      expect(find.iconWidget(Icons.favorite), findsOneWidget);
      expect(find.iconWidget(Icons.delete), findsNothing);
    });
  });

  group('find.imageAsset()', () {
    testWidgets('finds Image by asset name without resolving the asset', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: Image.asset(
            'assets/logo.png',
            errorBuilder: (_, _, _) => const SizedBox(),
          ),
        ),
      );

      expect(find.imageAsset('assets/logo.png'), findsOneWidget);
      expect(find.imageAsset('assets/other.png'), findsNothing);
    });
  });

  group('find.listTile()', () {
    testWidgets('finds ListTile by title text', (tester) async {
      await tester.pumpWidget(
        const TestApp(child: ListTile(title: Text('Settings'))),
      );

      expect(find.listTile('Settings'), findsOneWidget);
    });
  });

  group('find.tabWithLabel()', () {
    testWidgets('finds Tab by label text', (tester) async {
      await tester.pumpWidget(const TestApp(child: Tab(text: 'Profile')));

      expect(find.tabWithLabel('Profile'), findsOneWidget);
    });
  });

  group('find.dropdown()', () {
    testWidgets('finds DropdownButton by displayed label', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: DropdownButton<String>(
            value: 'us',
            onChanged: (_) {},
            items: const [
              DropdownMenuItem(value: 'us', child: Text('United States')),
              DropdownMenuItem(value: 'ca', child: Text('Canada')),
            ],
          ),
        ),
      );

      expect(find.dropdown('United States'), findsOneWidget);
      expect(find.dropdown('Missing'), findsNothing);
    });
  });

  group('find.chip()', () {
    testWidgets('finds chip by label text', (tester) async {
      await tester.pumpWidget(
        const TestApp(child: Chip(label: Text('Flutter'))),
      );

      expect(find.chip('Flutter'), findsOneWidget);
    });
  });

  group('field text finders', () {
    testWidgets('find by hint supports TextField and TextFormField', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: Column(
            children: [
              TextField(decoration: InputDecoration(hintText: 'Email')),
              TextFormField(decoration: InputDecoration(hintText: 'Password')),
            ],
          ),
        ),
      );

      expect(find.byHintText('Email'), findsOneWidget);
      expect(find.byHintText('Password'), findsOneWidget);
    });

    testWidgets('find by label supports TextField and TextFormField', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: Column(
            children: [
              TextField(decoration: InputDecoration(labelText: 'Email')),
              TextFormField(decoration: InputDecoration(labelText: 'Password')),
            ],
          ),
        ),
      );

      expect(find.byLabelText('Email'), findsOneWidget);
      expect(find.byLabelText('Password'), findsOneWidget);
    });
  });
}
