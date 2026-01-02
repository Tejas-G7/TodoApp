import 'dart:developer';

import 'package:http/http.dart' as http;

class TodoNetwork extends http.BaseClient {
  TodoNetwork._internal();

  static final TodoNetwork _instance = TodoNetwork._internal();

  factory TodoNetwork() {
    return _instance;
  }

  final http.Client _client = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = await _client.send(request);

    final bytes = await response.stream.toBytes();
    final body = String.fromCharCodes(bytes);

    log('HTTP ${request.method} ${request.url}');
    log('Status: ${response.statusCode}');
    log('Body: $body');

    return http.StreamedResponse(
      Stream.fromIterable([bytes]),
      response.statusCode,
      headers: response.headers,
      request: response.request,
      reasonPhrase: response.reasonPhrase,
    );
  }
}
