import 'package:chatdrop/settings/constants/database_constant.dart';
import 'package:chatdrop/shared/models/message_model/secret_message_model.dart';
import 'package:sqflite/sqflite.dart';

enum DeleteType {temporary, permanent}

class SecretChatMessageRepository {
  final _databaseName = DatabaseConstant.chatsDatabaseName;
  late String messageTable;
  late String recentTable;
  static Database? _db;
  late bool isTableCreated = false;

  Future<void> init() async {
    messageTable = DatabaseTableConstant.messageTableName;
    recentTable = DatabaseTableConstant.recentTableName;
    _db = await openDatabase(_databaseName,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE $messageTable (id INTEGER, chat_with TEXT, sender_uid TEXT, message_type TEXT, refer TEXT, content_type TEXT, content TEXT, is_delivered INTEGER, is_read INTEGER, is_deleted INTEGER, is_interrupted INTEGER, time INTEGER)');
        await db.execute('CREATE TABLE $recentTable (chat_with TEXT PRIMARY KEY, name TEXT, photo TEXT, gender TEXT, id INTEGER, FOREIGN KEY (id) REFERENCES $messageTable (id))');
      },
      onOpen: (db) async {
        isTableCreated = true;
      },
    );
  }

  Future<void> storeMessage(SecretMessageModel model) async {
    if (isTableCreated) {
      await _db?.rawInsert('INSERT INTO $messageTable(id, chat_with, sender_uid, message_type, refer, content_type, content, is_delivered, is_read, is_deleted, is_interrupted, time) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)', [
        model.id!,
        model.chatWith!,
        model.senderUid!,
        model.messageType!,
        model.refer,
        model.contentType!,
        model.content!,
        model.isDelivered! ? 1 : 0,
        model.isRead! ? 1 : 0,
        model.isDeleted! ? 1 : 0,
        model.isInterrupted! ? 1 : 0,
        model.time!,
      ]);
    }
  }

  Future<void> storeRecent(RecentSecretMessageModel model) async {
    if (isTableCreated) {
      List<Map<String, Object?>>? result = await _db?.rawQuery('SELECT * FROM $recentTable WHERE chat_with = ?', [model.chatWith]);
      if (result == null || result.isEmpty) {
        await _db?.rawInsert('INSERT INTO $recentTable(chat_with, name, photo, gender, id) VALUES(?,?,?,?,?)', [
          model.chatWith!,
          model.name!,
          model.photo!,
          model.gender!,
          model.messageId,
        ]);
      } else {
        await _db?.rawUpdate('UPDATE $recentTable SET name = ?, photo = ?, gender = ?, id = ? WHERE chat_with = ?', [
          model.name, model.photo, model.gender, model.messageId, model.chatWith
        ]);
      }
    }
  }

  Future<List<SecretMessageModel>> retrieveMessages(String chatWith) async {
    if (isTableCreated) {
      List<Map<String, Object?>>? result = await _db?.rawQuery('SELECT * FROM $messageTable WHERE chat_with = ? ORDER BY time ASC', [chatWith]);
      if (result != null) {
        return result.map((message) {
          return SecretMessageModel(
            id: message['id'] as int,
            chatWith: message['chat_with'] as String,
            senderUid: message['sender_uid'] as String,
            messageType: message['message_type'] as String,
            refer: message['refer'] as String?,
            contentType: message['content_type'] as String,
            content: message['content'] as String,
            isDelivered: (message['is_delivered'] as int) == 1,
            isRead: (message['is_read'] as int) == 1,
            isDeleted: (message['is_deleted'] as int) == 1,
            isInterrupted: (message['is_interrupted'] as int) == 1,
            time: message['time'] as int,
          );
        }).toList();
      }
      return [];
    }
    return [];
  }

  Future<SecretMessageModel?> retrieveMessage(int id, String chatWith) async {
    if (isTableCreated) {
      try {
        List<Map<String, Object?>>? result = await _db?.rawQuery('SELECT * FROM $messageTable WHERE id = ? AND chat_with = ?', [id, chatWith]);
        if (result != null) {
          Map<String, Object?> message = result[0];
          return SecretMessageModel(
            id: message['id'] as int,
            chatWith: message['chat_with'] as String,
            senderUid: message['sender_uid'] as String,
            messageType: message['message_type'] as String,
            refer: message['refer'] as String?,
            contentType: message['content_type'] as String,
            content: message['content'] as String,
            isDelivered: (message['is_delivered'] as int) == 1,
            isRead: (message['is_read'] as int) == 1,
            isDeleted: (message['is_deleted'] as int) == 1,
            isInterrupted: (message['is_interrupted'] as int) == 1,
            time: message['time'] as int,
          );
        }
      } catch(e) {
        return null;
      }
    }
    return null;
  }

  Future<List<RecentSecretMessageModel>> retrieveRecent() async {
    if (isTableCreated) {
      List<Map<String, Object?>>? result = await _db?.rawQuery('SELECT * FROM $recentTable');
      if (result != null) {
        return result.map((recent) {
          return RecentSecretMessageModel(
            chatWith: recent['chat_with'] as String,
            name: recent['name'] as String,
            photo: recent['photo'] as String,
            gender: recent['gender'] as String,
            messageId: recent['id'] as int,
          );
        }).toList();
      }
      return [];
    }
    return [];
  }

  Future<void> setIsReadTrue(String chatWith) async {
    if(isTableCreated) {
      await _db?.rawUpdate('UPDATE $messageTable SET is_read = ? WHERE chat_with = ?', [1, chatWith]);
    }
  }

  Future<void> setIsInterruptedFalse(int id, String chatWith, String content) async {
    if(isTableCreated) {
      await _db?.rawUpdate('UPDATE $messageTable SET is_interrupted = ?, content = ? WHERE id = ? AND chat_with = ?', [0, content, id, chatWith]);
    }
  }

  Future<void> deleteMessage(DeleteType type, int id, String chatWith) async {
    if (isTableCreated) {
      if(type == DeleteType.permanent) {
        await _db?.rawDelete('DELETE FROM $messageTable WHERE id = ? AND chat_with = ?', [id, chatWith]);
      } else {
        await _db?.rawUpdate('UPDATE $messageTable SET is_deleted = ? WHERE id = ? AND chat_with = ?', [1, id, chatWith]);
      }
    }
  }

  Future<void> deleteMessages(DeleteType type, String chatWith) async {
    if (isTableCreated) {
      if(type == DeleteType.permanent) {
        await _db?.rawDelete('DELETE FROM $messageTable WHERE chat_with = ?', [chatWith]);
      } else {
        await _db?.rawUpdate('UPDATE $messageTable SET is_deleted = ? WHERE chat_with = ?', [1, chatWith]);
      }
    }
  }

  Future<void> deleteRecent(String chatWith, int messageId) async {
    if (isTableCreated) {
      await _db?.rawDelete('DELETE FROM $recentTable WHERE chat_with = ? AND id = ?', [chatWith, messageId]);
    }
  }

  Future<void> deleteRecentFully(String chatWith) async {
    if (isTableCreated) {
      await _db?.rawDelete('DELETE FROM $recentTable WHERE chat_with = ?', [chatWith]);
    }
  }

  Future<void> deleteChatsTableRecords() async {
    if (isTableCreated) {
      await _db?.rawDelete('DELETE FROM $messageTable');
      await _db?.rawDelete('DELETE FROM $recentTable');
      isTableCreated = false;
    }
  }

  Future<void> close() async {
    await _db?.close();
  }
}