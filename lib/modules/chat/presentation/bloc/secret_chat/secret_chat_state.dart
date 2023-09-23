import '../../../../../shared/models/message_model/secret_message_model.dart';

abstract class SecretChatState {}

class SecretChatInitialState extends SecretChatState {}
class LoadingSecretChatState extends SecretChatState {}
class SecretChatListState extends SecretChatState {
  final List<SecretMessageModel> messages;
  SecretChatListState(this.messages);
}
class FailedSecretChatState extends SecretChatState {
  final String error;
  FailedSecretChatState(this.error);
}