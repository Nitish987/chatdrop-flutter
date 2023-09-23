import '../../../../../shared/models/message_model/secret_message_model.dart';

abstract class SecretChatEvent {}

class ListSecretChatEvent extends SecretChatEvent {
  List<SecretMessageModel> messages;

  ListSecretChatEvent(this.messages);
}

class AddSecretChatEvent extends SecretChatEvent {
  SecretMessageModel message;

  AddSecretChatEvent(this.message);
}

class DeleteSecretChatEvent extends SecretChatEvent {
  List<SecretMessageModel> selectedMessages;

  DeleteSecretChatEvent(this.selectedMessages);
}

class SecretMessageSelectionEvent extends SecretChatEvent {
  int id;
  List<SecretMessageModel> selectedMessages;
  SecretMessageSelectionEvent(this.id, this.selectedMessages);
}

class ClearSelectionEvent extends SecretChatEvent {
  List<SecretMessageModel> selectedMessages;
  ClearSelectionEvent(this.selectedMessages);
}

class RecoverInterruptedMessageEvent extends SecretChatEvent {
  SecretMessageModel message;

  RecoverInterruptedMessageEvent(this.message);
}

class ReadSecretChatEvent extends SecretChatEvent {}

class ClearSecretChatEvent extends SecretChatEvent {}