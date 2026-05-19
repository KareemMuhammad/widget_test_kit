import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Extensions on [WidgetTester] for navigation and overlay assertions.
///
/// ```dart
/// await tester.navigateTo('/profile');
/// tester.expectDialog();
/// await tester.dismissDialog();
/// ```
extension WidgetTesterNavigationExtensions on WidgetTester {
  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  /// Pushes the named route [routeName] onto the navigator and pumps.
  ///
  /// ```dart
  /// await tester.navigateTo('/settings');
  /// ```
  Future<void> navigateTo(String routeName) async {
    final context = element(find.byType(Navigator));
    Navigator.of(context).pushNamed(routeName);
    await pumpAndSettle();
  }

  /// Pops the current route (simulates pressing back) and pumps.
  ///
  /// ```dart
  /// await tester.goBack();
  /// ```
  Future<void> goBack() async {
    final context = element(find.byType(Navigator));
    Navigator.of(context).pop();
    await pumpAndSettle();
  }

  /// Asserts that the current top-level route has the given [routeName].
  ///
  /// ```dart
  /// tester.expectRoute('/home');
  /// ```
  void expectRoute(String routeName) {
    String? currentRoute;
    final context = element(find.byType(Navigator));
    Navigator.of(context).popUntil((route) {
      currentRoute = route.settings.name;
      return true;
    });
    expect(
      currentRoute,
      equals(routeName),
      reason: 'Expected current route to be "$routeName" but found "$currentRoute".',
    );
  }

  // ---------------------------------------------------------------------------
  // Dialogs & Overlays
  // ---------------------------------------------------------------------------

  /// Asserts that a [Dialog] or [AlertDialog] is currently in the widget tree.
  ///
  /// ```dart
  /// tester.expectDialog();
  /// ```
  void expectDialog() {
    final dialogFinder = find.byWidgetPredicate(
      (widget) => widget is Dialog || widget is AlertDialog,
    );
    expect(
      dialogFinder,
      findsWidgets,
      reason: 'Expected a Dialog to be visible, but none was found.',
    );
  }

  /// Asserts that no [Dialog] is currently in the widget tree.
  ///
  /// ```dart
  /// tester.expectNoDialog();
  /// ```
  void expectNoDialog() {
    final dialogFinder = find.byWidgetPredicate(
      (widget) => widget is Dialog || widget is AlertDialog,
    );
    expect(
      dialogFinder,
      findsNothing,
      reason: 'Expected no Dialog to exist, but one was found.',
    );
  }

  /// Asserts that a [BottomSheet] is currently visible.
  ///
  /// ```dart
  /// tester.expectBottomSheet();
  /// ```
  void expectBottomSheet() {
    expect(
      find.byType(BottomSheet),
      findsWidgets,
      reason: 'Expected a BottomSheet to be visible, but none was found.',
    );
  }

  /// Dismisses the topmost dialog by tapping its modal barrier.
  ///
  /// ```dart
  /// await tester.dismissDialog();
  /// ```
  Future<void> dismissDialog() async {
    // The ModalBarrier is rendered behind the dialog.
    await tapAt(Offset.zero);
    await pumpAndSettle();
  }

  /// Asserts that a [SnackBar] is visible, optionally checking its text.
  ///
  /// ```dart
  /// tester.expectSnackBar(withText: 'Saved!');
  /// ```
  void expectSnackBar({String? withText}) {
    expect(
      find.byType(SnackBar),
      findsOneWidget,
      reason: 'Expected a SnackBar to be visible, but none was found.',
    );

    if (withText != null) {
      expect(
        find.descendant(
          of: find.byType(SnackBar),
          matching: find.text(withText),
        ),
        findsOneWidget,
        reason: 'Expected SnackBar with text "$withText", but it was not found.',
      );
    }
  }
}

