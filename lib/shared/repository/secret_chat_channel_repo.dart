import 'dart:convert';

import 'package:chatdrop/infra/services/websocket_client.dart';
import 'package:chatdrop/shared/models/message_model/secret_message_model.dart';
import 'package:chatdrop/shared/services/user_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SecretChatChannelRepository {
  late WebSocketChannel _channel;

  Future<void> create(String uid) async {
    WebsocketClient websocketClient = WebsocketClient.instance;
    final token = UserService.webSocketAuthToken;
    final authHeaders = UserService.authHeaders;
    final path = 'chat/v1/secret/chat/$uid/?wat=$token&lst=${authHeaders['lst']}';
    _channel = websocketClient.connect(path: path);
  }

  Stream<dynamic> get stream {
    return _channel.stream;
  }

  void send(SecretMessageModel message) {
    _channel.sink.add(jsonEncode(message.toJson()));
  }

  Future<void> drop() async {
    await _channel.sink.close();
  }
}