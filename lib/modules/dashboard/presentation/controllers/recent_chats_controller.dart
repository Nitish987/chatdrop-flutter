import 'package:chatdrop/infra/utilities/aes.dart';
import 'package:chatdrop/shared/models/message_model/message_model.dart';
import 'package:chatdrop/shared/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecentChatsController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamRecentChats() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return firestore.collection('recents').doc(uid).collection('chats').orderBy('time', descending: true).snapshots();
  }

  void setIsReadTrue(MessageModel message, String uid) {
    if (message.isRead == false) {
      message.isRead = true;
      final myUid = FirebaseAuth.instance.currentUser!.uid;
      firestore.collection('recents').doc(myUid).collection('chats').doc(uid).update({'message': message.toJson()});
    }
  }

  String encryptContent(String content) {
    content = Aes256.encrypt(content, UserService.encryptionKey);
    return content;
  }

  String decryptContent(String content) {
    content = Aes256.decrypt(content, UserService.encryptionKey)!;
    return content;
  }
}