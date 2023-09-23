import 'dart:typed_data';

import 'package:chatdrop/infra/utilities/aes.dart';
import 'package:chatdrop/shared/models/message_model/message_model.dart';
import 'package:chatdrop/shared/models/post_model/post_model.dart';
import 'package:chatdrop/shared/models/reel_model/reel_model.dart';
import 'package:chatdrop/shared/models/user_model/user_model.dart';
import 'package:chatdrop/shared/services/reel_service.dart';
import 'package:chatdrop/shared/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../services/normal_chat_service.dart';
import '../services/post_service.dart';

class NormalChatController {
  late bool isInitialized;
  late UserModel remoteUser;
  late String? senderUid;
  late String? chatroom;
  late Function onDeleteFromEveryone, onDeleteFromMe;
  final List<MessageModel> selectedMessages = <MessageModel> [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final NormalChatService _chatService = NormalChatService();
  final PostService _postService = PostService();
  final ReelService _reelService = ReelService();


  NormalChatController() {
    isInitialized = false;
  }

  /// initializing chat controller
  void init(UserModel remoteUser, {Function? onDeleteFromEveryone, Function? onDeleteFromMe}) {
    this.remoteUser = remoteUser;
    this.onDeleteFromEveryone = onDeleteFromEveryone ?? () {};
    this.onDeleteFromMe = onDeleteFromMe ?? () {};
    senderUid = FirebaseAuth.instance.currentUser!.uid;
    isInitialized = true;
  }

  void changeStatus(String status) {
    firestore.collection('status').doc(senderUid!).set({'status': status});
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> listenStatusSignal() {
    return firestore.collection('status').doc(remoteUser.uid!).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listenMessageSignal() {
    return firestore.collection('normal_chats').doc(remoteUser.chatroom).collection(senderUid!).orderBy('time').snapshots();
  }

  String encryptContent(String content) {
    content = Aes256.encrypt(content, UserService.encryptionKey);
    return content;
  }

  String decryptContent(String content) {
    content = Aes256.decrypt(content, UserService.encryptionKey)!;
    return content;
  }

  Future<String> uploadMessageAttachment(String filename, Uint8List fileBytes) async {
    final reference = storage.ref().child(remoteUser.chatroom!).child(filename);
    await reference.putData(fileBytes);
    String url = await reference.getDownloadURL();
    return url;
  }

  void sendMessage(MessageModel message) async {
    message.chatWith = remoteUser.uid!;
    message.senderUid = senderUid;
    message.content = encryptContent(message.content!);
    await _chatService.sendMessage(message);
  }

  void setIsReadTrue(MessageModel message) {
    if (message.isRead! == false) {
      firestore.collection('normal_chats').doc(remoteUser.chatroom).collection(remoteUser.uid!).doc(message.id).update({'is_read': true});
    }
  }

  void deleteMessageFromEveryone() {
    if (selectedMessages.isNotEmpty) {
      String id = selectedMessages[0].id!;
      final senderChats = firestore.collection('normal_chats').doc(remoteUser.chatroom).collection(senderUid!).doc(id);
      final receiverChats = firestore.collection('normal_chats').doc(remoteUser.chatroom).collection(remoteUser.uid!).doc(id);
      senderChats.update({'is_deleted': true});
      receiverChats.update({'is_deleted': true});
      selectedMessages.clear();
      onDeleteFromEveryone();
    }
  }

  void deleteMessageFromMe() {
    for (final message in selectedMessages) {
      final senderChats = firestore.collection('normal_chats').doc(remoteUser.chatroom).collection(senderUid!).doc(message.id);
      senderChats.delete();
    }
    selectedMessages.clear();
    onDeleteFromMe();
  }

  void removeFromRecent() {
    firestore.collection('recents').doc(senderUid).collection('chats').doc(remoteUser.uid!).delete();
  }

  Future<PostModel?> retrievePostMessage(String postId) async {
    PostModel? model = await _postService.viewPost(postId);
    return model;
  }

  Future<ReelModel?> retrieveReelMessage(String reelId) async {
    ReelModel? model = await _reelService.viewReel(reelId);
    return model;
  }
}