sealed class ResponseBody<T> {
  ResponseBody({required this.body});

  T? body;
}

final class StringResponseBody extends ResponseBody<String> {
  StringResponseBody({required super.body});
}

final class BytesResponseBody extends ResponseBody<List<int>> {
  BytesResponseBody({required super.body});
}

final class MapResponseBody extends ResponseBody<Map<String, dynamic>> {
  MapResponseBody({required super.body});
}
