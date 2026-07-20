import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

/// A 1x1 transparent PNG served for every request intercepted by
/// [mockNetworkImages].
final Uint8List _kTransparentImage = Uint8List.fromList(<int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, //
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
]);

/// Runs [body] with every [HttpClient] request — as issued by [NetworkImage]
/// / `Image.network` — transparently redirected to an in-memory 1x1 PNG.
///
/// Widget and golden tests that render `Image.network` normally fail or hang
/// because there is no real network access in the test environment. Wrap the
/// pump/expect calls that touch network images in [mockNetworkImages] instead
/// of hand-writing an `HttpOverrides` mock per test:
///
/// ```dart
/// await mockNetworkImages(() async {
///   await tester.pumpWidget(TestApp(child: ProfileAvatar()));
///   await tester.expectGolden('profile_avatar');
/// });
/// ```
///
/// Flutter's [NetworkImage] caches a single [HttpClient] the first time any
/// network image is loaded in the process, so call [mockNetworkImages] around
/// the *first* network-image-touching operation in a test run for it to take
/// effect reliably.
Future<T> mockNetworkImages<T>(Future<T> Function() body) async {
  final previous = HttpOverrides.current;
  HttpOverrides.global = _FakeImageHttpOverrides();
  try {
    return await body();
  } finally {
    HttpOverrides.global = previous;
  }
}

class _FakeImageHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _FakeHttpClient();
}

class _FakeHttpClient implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _FakeHttpClientRequest();

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async =>
      _FakeHttpClientRequest();

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeHttpClientRequest implements HttpClientRequest {
  @override
  final HttpHeaders headers = _FakeHttpHeaders();

  @override
  Future<HttpClientResponse> close() async => _FakeHttpClientResponse();

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeHttpHeaders implements HttpHeaders {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeHttpClientResponse implements HttpClientResponse {
  @override
  int get statusCode => HttpStatus.ok;

  @override
  int get contentLength => _kTransparentImage.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.value(_kTransparentImage).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError ?? false,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}
