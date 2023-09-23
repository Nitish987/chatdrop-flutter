import 'package:chatdrop/settings/utilities/directory_settings.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/foundation.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoEditorApi {
  static Future<String?> generateThumbnail(String videoPath) async {
    String tempDir = await DirectorySettings.tempMediaDirectoryPath;
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: tempDir,
      imageFormat: ImageFormat.PNG,
      quality: 100,
    );
    return thumbnailPath;
  }

  static Future<String?> compressVideo(String inputVideoPath) async {
    try {
      // debugPrint(File(inputVideoPath).lengthSync().toString());
      await VideoCompress.setLogLevel(0);
      final info = await VideoCompress.compressVideo(
        inputVideoPath,
        quality: VideoQuality.DefaultQuality,
        deleteOrigin: true,
        includeAudio: true,
      );
      if (info != null) {
        debugPrint('Video Compression Finished');
        // debugPrint(File(info.path!).lengthSync().toString());
        return info.path;
      }
      debugPrint('Video Compression Failed');
    } catch(e) {
      VideoCompress.cancelCompression();
    }
    return null;
  }

  static Future<String?> replaceAudioFromVideo(String inputVideoPath, String inputAudioPath, String outputDir, String filename) async {
    final outputVideoPath = '$outputDir/$filename';
    final query = '-i $inputVideoPath -i $inputAudioPath -c:v copy -map 0:v:0 -map 1:a:0 $outputVideoPath';
    final session = await FFmpegKit.execute(query);
    final returnCode = await session.getReturnCode();
    if (ReturnCode.isSuccess(returnCode)) {
      debugPrint('Video Audio Combination Finished');
      final compressedVideoPath = await compressVideo(outputVideoPath);
      return compressedVideoPath;
    } else if (ReturnCode.isCancel(returnCode)) {
      debugPrint('Video Audio Combination Cancel');
    } else {
      debugPrint('Video Audio Combination Error');
    }
    return null;
  }
}