// Response Collector for checking the success of request and sends the data or error respectively
class ResponseCollector {
  Map<String, dynamic>? _response;

  ResponseCollector._(this._response);

  factory ResponseCollector.collect(Map<String, dynamic>? response) {
    return ResponseCollector._(response);
  }

  bool get success => _response?['success'];

  Map<String, dynamic>? get data => _response?['data'];

  String get error {
    Map<String, dynamic>? errors = _response?['errors'];
    return errors?[errors.keys.first][0];
  }
}
