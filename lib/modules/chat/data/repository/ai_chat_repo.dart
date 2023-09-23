import 'package:chatdrop/settings/constants/database_constant.dart';
import 'package:chatdrop/modules/chat/data/models/message_model/ai_message_model.dart';
import 'package:sqflite/sqflite.dart';

class AiChatRepository {
  final _databaseName = DatabaseConstant.aiDatabaseName;
  late String oliviaTable;
  static Database? _db;
  late bool isTableCreated = false;

  Future<void> init() async {
    oliviaTable = DatabaseTableConstant.oliviaTableName;
    _db = await openDatabase(_databaseName,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE $oliviaTable (id INTEGER, sender_uid TEXT, content_type TEXT, content TEXT, time INTEGER)');
      },
      onOpen: (db) {
        isTableCreated = true;
      },
    );
  }

  Future<void> storeMessage(AiMessageModel model) async {
    if (isTableCreated) {
      await _db?.rawInsert('INSERT INTO $oliviaTable(id, sender_uid, content_type, content, time) VALUES(?,?,?,?,?)', [
        model.id!,
        model.senderUid!,
        model.contentType!,
        model.content!,
        model.time!,
      ]);
    }
  }

  Future<List<AiMessageModel>> retrieveMessages() async {
    if (isTableCreated) {
      List<Map<String, Object?>>? result = await _db?.rawQuery('SELECT * FROM $oliviaTable ORDER BY time ASC');
      if (result != null) {
        return result.map((message) {
          return AiMessageModel(
            id: message['id'] as int,
            senderUid: message['sender_uid'] as String,
            contentType: message['content_type'] as String,
            content: message['content'] as String,
            time: message['time'] as int,
          );
        }).toList();
      }
      return [];
    }
    return [];
  }

  Future<void> deleteMessages(List<AiMessageModel> messages) async {
    if (isTableCreated) {
      for (AiMessageModel message in messages) {
        await _db?.rawDelete('DELETE FROM $oliviaTable WHERE id = ?', [message.id]);
      }
    }
  }

  Future<void> clearChats() async {
    if (isTableCreated) {
      await _db?.rawDelete('DELETE FROM $oliviaTable');
    }
  }

  void close() async {
    await _db?.close();
  }
}