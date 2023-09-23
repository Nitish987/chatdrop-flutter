import 'dart:io';

import 'package:flutter/foundation.dart';

class FileDownloaderApi {
  static Future<File?> downloadFile(String url, String savePath) async {
    try {
      var httpClient = HttpClient();
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      File file = File(savePath);
      await file.writeAsBytes(bytes);
      debugPrint('File Downloaded');
      return file;
    } catch (error) {
      return null;
    }
  }
}