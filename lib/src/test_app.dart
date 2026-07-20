import 'package:flutter/material.dart';

/// A minimal app wrapper for widget tests.
///
/// Wraps [child] in a [MaterialApp] and [Scaffold], eliminating the
/// boilerplate that every widget test otherwise requires.
///
/// ```dart
/// await tester.pumpWidget(
///   TestApp(
///     child: LoginForm(),
///     theme: ThemeData.dark(),
///     locale: const Locale('fr'),
///   ),
/// );
/// ```
class TestApp extends StatelessWidget {
  /// The widget under test.
  final Widget child;

  /// Optional [ThemeData] applied to the [MaterialApp].
  final ThemeData? theme;

  /// Optional dark [ThemeData] applied to the [MaterialApp].
  final ThemeData? darkTheme;

  /// Optional locale for the app.
  final Locale? locale;

  /// Locales the app supports. Defaults to `[Locale('en')]`.
  final List<Locale>? supportedLocales;

  /// Localization delegates forwarded to [MaterialApp].
  final List<LocalizationsDelegate>? localizationsDelegates;

  /// Navigator observers forwarded to [MaterialApp].
  final List<NavigatorObserver>? navigatorObservers;

  /// Named routes forwarded to [MaterialApp].
  final Map<String, WidgetBuilder>? routes;

  /// Optional outer wrapper applied around the [MaterialApp], e.g. to inject
  /// a `ProviderScope`, `BlocProvider`, or other inherited state without this
  /// package depending on any state-management library directly.
  ///
  /// ```dart
  /// await tester.pumpWidget(
  ///   TestApp(
  ///     wrapper: (app) => ProviderScope(child: app),
  ///     child: LoginForm(),
  ///   ),
  /// );
  /// ```
  final Widget Function(Widget app)? wrapper;

  /// Creates a [TestApp] wrapping [child].
  const TestApp({
    super.key,
    required this.child,
    this.theme,
    this.darkTheme,
    this.locale,
    this.supportedLocales,
    this.localizationsDelegates,
    this.navigatorObservers,
    this.routes,
    this.wrapper,
  });

  @override
  Widget build(BuildContext context) {
    final app = MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      darkTheme: darkTheme,
      locale: locale,
      supportedLocales: supportedLocales ?? const [Locale('en')],
      localizationsDelegates: localizationsDelegates,
      navigatorObservers: navigatorObservers ?? const [],
      routes: routes ?? const {},
      home: Scaffold(body: child),
    );

    return wrapper?.call(app) ?? app;
  }
}
