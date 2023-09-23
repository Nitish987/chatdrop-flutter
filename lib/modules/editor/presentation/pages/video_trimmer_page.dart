import 'dart:io';
import 'package:chatdrop/shared/widgets/appbar_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_trimmer/video_trimmer.dart';

import '../providers/video_trimmer_provider.dart';

class VideoTrimmerPage extends StatefulWidget {
  final String videoPath;

  const VideoTrimmerPage({Key? key, required this.videoPath}) : super(key: key);

  @override
  State<VideoTrimmerPage> createState() => _VideoTrimmerPageState();
}

class _VideoTrimmerPageState extends State<VideoTrimmerPage> {
  final Trimmer _trimmer = Trimmer();

  @override
  void initState() {
    super.initState();
    _trimmer.loadVideo(videoFile: File(widget.videoPath));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VideoTrimmerProvider>(
      create: (context) => VideoTrimmerProvider(),
      child:
          Consumer<VideoTrimmerProvider>(builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: const AppBarTitle(title: 'Video Trim'),
            actions: [
              IconButton(
                onPressed: () {
                  _trimmer.saveTrimmedVideo(
                    startValue: provider.startValue,
                    endValue: provider.endValue,
                    onSave: (outputPath) {
                      Navigator.pop(context, outputPath);
                    },
                  );
                },
                icon: const Icon(
                  Icons.check,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          body: InkWell(
            onTap: () async {
              bool isPlaying = await _trimmer.videoPlaybackControl(
                startValue: provider.startValue,
                endValue: provider.endValue,
              );
              provider.setIsPlaying(isPlaying);
            },
            child: Center(
              child: VideoViewer(trimmer: _trimmer),
            ),
          ),
          bottomSheet: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: TrimViewer(
              trimmer: _trimmer,
              viewerHeight: 50.0,
              viewerWidth: MediaQuery.of(context).size.width,
              type: ViewerType.fixed,
              maxVideoLength: const Duration(seconds: 15),
              editorProperties: const TrimEditorProperties(
                circlePaintColor: Colors.blue,
                borderPaintColor: Colors.blue,
                scrubberPaintColor: Colors.blue,
              ),
              areaProperties: const TrimAreaProperties(
                thumbnailFit: BoxFit.cover,
                thumbnailQuality: 50,
              ),
              paddingFraction: 0.5,
              durationStyle: DurationStyle.FORMAT_MM_SS,
              onChangeStart: (value) => provider.setStartValue(value),
              onChangeEnd: (value) => provider.setEndValue(value),
              onChangePlaybackState: (value) => provider.setIsPlaying(value),
            ),
          ),
        );
      }),
    );
  }
}
