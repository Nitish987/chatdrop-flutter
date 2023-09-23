import 'package:chatdrop/shared/models/message_model/secret_message_model.dart';

class RecentSecretChatModel {
  RecentSecretMessageModel? recent;
  SecretMessageModel? message;

  RecentSecretChatModel(this.recent, this.message);
}