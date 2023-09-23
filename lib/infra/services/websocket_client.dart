import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// Websocket Client for communicating with server
class WebsocketClient {
  late String _baseUrl;
  static final instance = WebsocketClient._();

  WebsocketClient._() {
    _baseUrl = dotenv.env['WEBSOCKET_URL']!;
  }

  WebSocketChannel connect({required String path}) {
    String url = _baseUrl + path;
    return WebSocketChannel.connect(Uri.parse(url));
  }
}