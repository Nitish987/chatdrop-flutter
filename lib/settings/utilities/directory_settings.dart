import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DirectorySettings {
  static configDirs() async {
      try {
        String cacheDirPath = await cacheDirectoryPath;
        Directory cacheDir = Directory(cacheDirPath);
        if (! await cacheDir.exists()) {
          await cacheDir.create();
        }
        String editorDirPath = await editorDirectoryPath;
        Directory editorDir = Directory(editorDirPath);
        if (! await editorDir.exists()) {
          await editorDir.create();
        }
        String tempMediaDirPath = await tempMediaDirectoryPath;
        Directory tempMediaDir = Directory(tempMediaDirPath);
        if (! await tempMediaDir.exists()) {
          await tempMediaDir.create();
        }
      } catch(e) {
        return;
      }
  }

  static Future<String> get cacheDirectoryPath async {
    return '${(await getExternalStorageDirectory())!.path}/Cache';
  }

  static Future<String> get editorDirectoryPath async {
    return '${(await getApplicationDocumentsDirectory()).path}/Editor';
  }

  static Future<String> get trimmerDirectoryPath async {
    return '${(await getApplicationDocumentsDirectory()).path}/Trimmer';
  }

  static Future<String> get tempMediaDirectoryPath async {
    return '${(await getTemporaryDirectory()).path}/Media';
  }
}