import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:chatdrop/infra/utilities/file_type.dart';
import 'package:chatdrop/modules/camera/presentation/cubit/camera_feature/camera_feature_cubit.dart';
import 'package:chatdrop/modules/camera/presentation/cubit/camera_feature/camera_feature_state.dart';
import 'package:chatdrop/settings/hardware/hardware.dart';
import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/settings/utilities/directory_settings.dart';
import 'package:chatdrop/shared/models/audio_model/audio_model.dart';
import 'package:chatdrop/shared/api/video_editor_api.dart';
import 'package:chatdrop/shared/api/file_downloader_api.dart';
import 'package:chatdrop/shared/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late final CameraFeatureCubit _feature = BlocProvider.of<CameraFeatureCubit>(context);
  final AudioPlayer _audioPlayer = AudioPlayer();
  late AudioModel _audio;
  late int _videoDurationSeconds = 60;
  late CameraController _cameraController;
  late StreamSubscription<int> _saveVideoSubscription;

  void _setUpAudioForReel() async {
    Duration? duration = await _audioPlayer.setUrl(_audio.url!);
    if (duration == null && mounted) {
      Navigator.pop(context);
    }
    _videoDurationSeconds = duration!.inSeconds;
    _feature.changeFeature(ReelCameraState(isSetupFinish: true));
  }

  void _savePhoto() {
    _feature.changeFeature(PhotoCameraState(isClicking: true));
    _cameraController.takePicture().then((xFile) {
      _feature.changeFeature(PhotoCameraState(isClicking: false));
      Navigator.pushNamed(context, Routes.cameraCaptured, arguments: {
        'type': FileType.image,
        'path': xFile.path,
      });
    });
  }

  void _saveVideo() {
    try {
      if (_cameraController.value.isRecordingVideo) {
        _feature.changeFeature(VideoCameraState(isRecording: false));
        _cameraController.stopVideoRecording().then((xFile) {
          Navigator.pushNamed(context, Routes.cameraCaptured, arguments: {
            'type': FileType.video,
            'path': xFile.path,
          });
        });
      }
    } catch(e) {
      debugPrint('Video not saved');
    }
  }

  void _resumeVideo() {
    _cameraController.resumeVideoRecording();
  }

  void _startVideo() {
    _videoDurationSeconds = 60;
    _cameraController.startVideoRecording().then((value) {
      _feature.changeFeature(VideoCameraState(isRecording: true));
      _saveVideoSubscription = _videoDurationTimerStream.listen((seconds) {
        if (seconds == _videoDurationSeconds) {
          _saveVideo();
        }
      });
    });
  }

  void _saveReel() async {
    try {
      if (_cameraController.value.isRecordingVideo) {
        _feature.changeFeature(ReelCameraState(isSetupFinish: true, isRecording: false));
        // stopping reel recording
        final xFile = await _cameraController.stopVideoRecording();
        _audioPlayer.stop();
        _saveVideoSubscription.cancel();

        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => ProgressDialog(
              label: 'Processing...',
              whileProgress: () {
                // getting temp media directory
                DirectorySettings.tempMediaDirectoryPath.then((dir) {
                  // downloading audio file in temp directory
                  FileDownloaderApi.downloadFile(_audio.url!, '$dir/${_audio.filename!}').then((file) async {
                    // creating output video by replacing recorded audio with actual reel audio
                    if (file != null) {
                      final videoFilename = '${DateTime.now().millisecondsSinceEpoch}.mp4';
                      String? outputVideoPath = await VideoEditorApi.replaceAudioFromVideo(xFile.path, file.path, dir, videoFilename);
                      if (outputVideoPath != null && mounted) {
                        Navigator.popAndPushNamed(context, Routes.reel, arguments: {
                          'file': File(outputVideoPath),
                          'audio': _audio,
                        });
                      }
                    } else {
                      Navigator.pop(context);
                    }
                  });
                });
              },
            ),
          );
        }
      }
    } catch(e) {
      debugPrint('Reel not saved');
    }
  }

  void _resumeReel() {
    _audioPlayer.play();
    _cameraController.resumeVideoRecording();
    _saveVideoSubscription.resume();
    debugPrint('Reel Recording Resume');
  }

  void _pauseReel() {
    _audioPlayer.pause();
    _cameraController.pauseVideoRecording();
    _saveVideoSubscription.pause();
    debugPrint('Reel Recording Paused');
  }

  void _startReel() {
    _cameraController.startVideoRecording().then((value) async {
      await _audioPlayer.seek(const Duration(seconds: 0));
      _audioPlayer.play();
      _feature.changeFeature(ReelCameraState(isSetupFinish: true, isRecording: true));
      _saveVideoSubscription = _videoDurationTimerStream.listen((seconds) {
          if (seconds == _videoDurationSeconds) {
            _saveReel();
          }
      });
    });
  }

  void _onCameraAction() {
    if (_feature.state is PhotoCameraState) {
      _savePhoto();
    } else if (_feature.state is VideoCameraState) {
      if (_cameraController.value.isRecordingPaused) {
        _resumeVideo();
      } else if (_cameraController.value.isRecordingVideo){
        _saveVideo();
      } else {
        _startVideo();
      }
    } else if (_feature.state is ReelCameraState && (_feature.state as ReelCameraState).isSetupFinish) {
      if (_cameraController.value.isRecordingPaused) {
        _resumeReel();
      } else if (_cameraController.value.isRecordingVideo){
        _pauseReel();
      } else {
        _startReel();
      }
    }
  }

  IconData get _getFeatureIcon {
    if (_feature.state is PhotoCameraState) {
      return Icons.photo_outlined;
    } else if (_feature.state is VideoCameraState) {
      return Icons.videocam_outlined;
    } else if (_feature.state is ReelCameraState) {
      return Icons.video_camera_back_outlined;
    }
    return Icons.camera_alt_outlined;
  }

  Stream<int> get _videoDurationTimerStream async* {
    int sec = 1, preSec = 0;
    while (sec <= _videoDurationSeconds) {
      await Future.delayed(const Duration(seconds: 1));
      if (_saveVideoSubscription.isPaused) {
        yield preSec;
      } else {
        yield sec;
        sec++;
      }
      preSec = sec;
    }
  }

  @override
  void initState() {
    _cameraController = CameraController(Cameras.cameras[0], ResolutionPreset.max);
    _cameraController.initialize().then((_) {
      _cameraController.setFocusMode(FocusMode.auto);
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// camera view
          if (_cameraController.value.isInitialized)
            GestureDetector(
              onScaleUpdate: (details) {
                if (details.scale >= 1 && details.scale <= 8) {
                  _cameraController.setZoomLevel(details.scale);
                }
              },
              child: Center(
                child: Transform.scale(
                  scale: media.size.aspectRatio + 0.8,
                  child: SizedBox(
                    width: media.size.width,
                    child: CameraPreview(_cameraController),
                  ),
                ),
              ),
            ),

          /// close camera options
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // reel options
          BlocBuilder<CameraFeatureCubit, CameraFeatureState>(
            builder: (context, state) {
              if (state is ReelCameraState) {
                String buttonText = 'Select Audio';
                if (state.isSetupFinish) {
                  if (_audio.name!.length < 9) {
                    buttonText = '${_audio.name!}...';
                  } else {
                    buttonText = '${_audio.name!.substring(0, 9)}...';
                  }
                }
                return Positioned(
                  bottom: 140,
                  child: Container(
                    margin: const EdgeInsets.only(left: 40, bottom: 10),
                    child: Column(
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, Routes.audio).then((audio) {
                                if (audio != null) {
                                  _audio = audio as AudioModel;
                                  _setUpAudioForReel();
                                }
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.multitrack_audio, color: Colors.white, size: 15),
                                const SizedBox(width: 5),
                                Text(buttonText, style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),

          /// camera controlling options
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 90,
              margin: const EdgeInsets.all(40),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: BlocBuilder<CameraFeatureCubit, CameraFeatureState>(
                builder: (context, state) {
                  Color backgroundColor = Colors.white;
                  if ((state is VideoCameraState || state is ReelCameraState) && state.isProcessing) {
                    backgroundColor = Colors.red;
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      /// image button
                      if (!state.isProcessing)
                        GestureDetector(
                          onTap: () {
                            _feature.changeFeature(PhotoCameraState());
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: const Icon(
                              Icons.image_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),

                      /// video button
                      if (!state.isProcessing)
                        GestureDetector(
                          onTap: () {
                            _feature.changeFeature(VideoCameraState());
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: const Icon(
                              Icons.videocam_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),

                      /// main action button
                      GestureDetector(
                        onTap: _onCameraAction,
                        child: SizedBox(
                          width: 90,
                          height: 90,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 45,
                                backgroundColor: backgroundColor,
                                child: CircleAvatar(
                                  radius: 43.5,
                                  backgroundColor: Colors.white,
                                  child: Icon(_getFeatureIcon, color: Colors.black),
                                ),
                              ),

                              /// Image Progress
                              if (state is PhotoCameraState && state.isProcessing)
                                const Center(
                                  child: SizedBox(
                                    width: 90,
                                    height: 90,
                                    child: CircularProgressIndicator(
                                      color: Colors.red,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),

                              /// Video or Reel Timer Progress
                              if ((state is VideoCameraState || state is ReelCameraState) && state.isProcessing)
                                Center(
                                  child: SizedBox(
                                    width: 90,
                                    height: 90,
                                    child: StreamBuilder<int>(
                                        stream: _videoDurationTimerStream,
                                        builder: (context, snap) {
                                          if (snap.data == null) {
                                            return const CircularProgressIndicator(
                                              color: Colors.white,
                                            );
                                          }

                                          double per = snap.data! / (_videoDurationSeconds / 100);
                                          return CircularProgressIndicator(
                                            value: per * 0.01,
                                            color: Colors.white,
                                          );
                                        }
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      /// reel button
                      if (!state.isProcessing)
                        GestureDetector(
                          onTap: () {
                            _feature.changeFeature(ReelCameraState());
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: const Icon(
                              Icons.video_camera_back_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),

                      /// change camera button
                      if (!state.isProcessing)
                        GestureDetector(
                          onTap: () {
                            if (_cameraController.description == Cameras.cameras[0]) {
                              _cameraController.setDescription(Cameras.cameras[1]);
                            } else {
                              _cameraController.setDescription(Cameras.cameras[0]);
                            }
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: const Icon(
                              Icons.loop_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  );
                }
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _cameraController.dispose();
    super.dispose();
  }
}
