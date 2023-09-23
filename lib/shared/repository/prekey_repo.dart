import 'package:chatdrop/infra/utilities/aes.dart';
import 'package:chatdrop/infra/utilities/convert.dart';
import 'package:chatdrop/settings/constants/keys_constant.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:sqflite/sqflite.dart';
import '../../settings/constants/database_constant.dart';

class PreKeyRepository {
  static final instance = PreKeyRepository._();
  final _databaseName = DatabaseConstant.preKeyDatabaseName;
  late String table = DatabaseTableConstant.preKeyTableName;
  static Database? _db;
  late bool isTableCreated = false;

  PreKeyRepository._();

  Future<void> initialize() async {
    _db = await openDatabase(_databaseName, version: 1,
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE $table (id INTEGER PRIMARY KEY, pair TEXT)');
      },
      onOpen: (db) {
        isTableCreated = true;
      }
    );
  }

  Future<void> storePreKeys(List<PreKeyRecord> models) async {
    if (isTableCreated) {
      for (var e in models) {
        final int id = e.id;
        String serializedPair = bytesToBase64(e.serialize());
        serializedPair = Aes256.encrypt(serializedPair, Keys.appEncryptionKey);
        await _db?.rawInsert('INSERT INTO $table(id, pair) VALUES(?,?)', [id, serializedPair]);
      }
    }
  }

  Future<List<PreKeyRecord>> retrievePreKey() async {
    if (isTableCreated) {
      List<Map<String, Object?>>? result = await _db?.query(table);
      if (result != null) {
        return result.map((e) {
          String? serializedPair = Aes256.decrypt(e['pair'] as String, Keys.appEncryptionKey);
          return PreKeyRecord.fromBuffer(base64ToBytes(serializedPair!));
        }).toList();
      }
      return [];
    }
    return [];
  }

  Future<void> deletePreKey(int id) async {
    if (isTableCreated) {
      await _db?.rawDelete('DELETE FROM $table WHERE id = ?', [id]);
    }
  }

  Future<void> deletePreKeysTableRecords() async {
    if (isTableCreated) {
      await _db?.rawDelete('DELETE FROM $table');
    }
  }

  Future<void> close() async {
    await _db?.close();
  }
}
