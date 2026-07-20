import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_app.dart';

/// Extensions on [WidgetTester] for golden (snapshot) testing helpers.
///
/// ```dart
/// await tester.expectGolden('login_page');
/// ```
extension WidgetTesterGoldenExtensions on WidgetTester {
  // ---------------------------------------------------------------------------
  // Golden comparisons
  // ---------------------------------------------------------------------------

  /// Compares the full app screenshot against a golden file at
  /// `goldens/[name].png`.
  ///
  /// If [surfaceSize] is provided, the test surface is resized before capturing.
  /// Use [goldenPath] to override the default `goldens/[name].png` path.
  ///
  /// ```dart
  /// await tester.expectGolden('home_screen', surfaceSize: Size(400, 800));
  /// ```
  Future<void> expectGolden(
    String name, {
    Size? surfaceSize,
    String? goldenPath,
  }) async {
    if (surfaceSize != null) {
      await binding.setSurfaceSize(surfaceSize);
      await pump();
    }

    try {
      await pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(goldenPath ?? 'goldens/$name.png'),
      );
    } finally {
      if (surfaceSize != null) {
        await binding.setSurfaceSize(null);
        await pump();
      }
    }
  }

  /// Compares a specific widget against a golden file at
  /// `goldens/[name].png`.
  ///
  /// Use [goldenPath] to override the default `goldens/[name].png` path.
  ///
  /// ```dart
  /// await tester.expectWidgetGolden(find.byKey(Key('avatar')), 'avatar');
  /// ```
  Future<void> expectWidgetGolden(
    Finder finder,
    String name, {
    String? goldenPath,
  }) async {
    await pumpAndSettle();
    await expectLater(
      finder,
      matchesGoldenFile(goldenPath ?? 'goldens/$name.png'),
    );
  }

  /// Pumps [child] wrapped in [TestApp] once per locale in [locales],
  /// capturing a golden file named `[name]_<languageCode>.png` for each.
  ///
  /// Useful for catching layout breakage (overflow, RTL mirroring, text
  /// truncation) across localizations in a single call.
  ///
  /// ```dart
  /// await tester.expectGoldenForLocales(
  ///   child: LoginForm(),
  ///   name: 'login_form',
  ///   locales: [Locale('en'), Locale('ar')],
  /// );
  /// ```
  Future<void> expectGoldenForLocales({
    required Widget child,
    required String name,
    required List<Locale> locales,
    Size? surfaceSize,
  }) async {
    for (final locale in locales) {
      await pumpWidget(
        TestApp(locale: locale, supportedLocales: locales, child: child),
      );
      await expectGolden(
        '${name}_${locale.languageCode}',
        surfaceSize: surfaceSize,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Screen size helpers
  // ---------------------------------------------------------------------------

  /// Sets the test surface to [width] x [height] for consistent golden tests.
  ///
  /// ```dart
  /// await tester.setScreenSize(width: 375, height: 812); // iPhone X
  /// ```
  Future<void> setScreenSize({double width = 400, double height = 800}) async {
    await binding.setSurfaceSize(Size(width, height));
    await pump();
  }

  /// Resets the surface size to default.
  ///
  /// ```dart
  /// await tester.resetScreenSize();
  /// ```
  Future<void> resetScreenSize() async {
    await binding.setSurfaceSize(null);
    await pump();
  }
}
