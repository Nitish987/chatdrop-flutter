import 'dart:io';
import 'dart:typed_data';
import 'package:chatdrop/settings/utilities/directory_settings.dart';
import 'package:chatdrop/shared/widgets/appbar_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../data/models/color_model.dart';
import '../../data/models/draw_point_model.dart';
import '../../domain/tools/sketch_canvas.dart';
import '../providers/image_editor_provider.dart';
import '../widgets/text_adder_dialog.dart';

class ImageEditorPage extends StatefulWidget {
  final String? imagePath;
  final String? bgName;

  const ImageEditorPage(
      {Key? key, this.imagePath, this.bgName})
      : super(key: key);

  @override
  State<ImageEditorPage> createState() => _ImageEditorPageState();
}

class _ImageEditorPageState extends State<ImageEditorPage> {
  final ScreenshotController _screenshotController = ScreenshotController();
  final List<ColorModel> _colors = ColorModel.getColorsList();

  ImageProvider<Object> _getWorkingImage() {
    if (widget.bgName == null) return FileImage(File(widget.imagePath!));
    return AssetImage('assets/bg/${widget.bgName!}');
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ImageEditorProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const AppBarTitle(title: 'Photo Editor'),
          actions: [
            IconButton(
              onPressed: () async {
                Uint8List? bytes = await _screenshotController.capture();
                String cacheDirPath = await DirectorySettings.editorDirectoryPath;
                File file = File(
                  "$cacheDirPath/${DateTime.now().millisecondsSinceEpoch}.png",
                );
                await file.writeAsBytes(bytes as List<int>);
                if (mounted) {
                  Navigator.pop(context, file.path);
                }
              },
              icon: const Icon(
                Icons.check,
                color: Colors.blue,
              ),
            )
          ],
        ),
        body: Consumer<ImageEditorProvider>(
          builder: (context, provider, child) {
            return Stack(
              children: [
                Column(
                  children: [
                    if (provider.isPenActive || provider.isTextAdderActive)
                      Container(
                        height: 60,
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _colors.map(
                            (color) {
                              return InkWell(
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.grey,
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: color.color,
                                  ),
                                ),
                                onTap: () {
                                  if (provider.isPenActive) {
                                    provider.changePenColor(color.color);
                                  } else if (provider.isTextAdderActive) {
                                    provider.changeTextColor(color.color);
                                  }
                                },
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    if (provider.isTextAdderActive && provider.texts.isNotEmpty)
                      Slider(
                        value: provider.textStyle.fontSize!,
                        max: 50,
                        divisions: 10,
                        label: provider.textStyle.fontSize!.toString(),
                        onChanged: (double value) {
                          provider.changeSelectedTextFontSize(value);
                        },
                      ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Screenshot(
                    controller: _screenshotController,
                    child: Center(
                      child: Stack(
                        children: [
                          /// Sketch Pen Tool
                          GestureDetector(
                            onPanStart: (value) {
                              if (provider.isPenActive) {
                                provider.addPenSketchPoints(
                                  DrawPointModel(
                                    position: value.localPosition,
                                    paint: Paint()
                                      ..color = provider.penColor
                                      ..strokeWidth = provider.penStrokeWidth
                                      ..strokeCap = StrokeCap.round,
                                  ),
                                );
                              }
                            },
                            onPanUpdate: (value) {
                              if (provider.isPenActive) {
                                provider.addPenSketchPoints(
                                  DrawPointModel(
                                    position: value.localPosition,
                                    paint: Paint()
                                      ..color = provider.penColor
                                      ..strokeWidth = provider.penStrokeWidth
                                      ..strokeCap = StrokeCap.round,
                                  ),
                                );
                              }
                            },
                            onPanEnd: (value) {
                              if (provider.isPenActive) {
                                provider.addPenSketchPoints(null);
                              }
                            },
                            child: CustomPaint(
                              foregroundPainter:
                                  SketchCanvasPainter(provider.drawPoints),
                              child: Image(
                                image: _getWorkingImage(),
                                fit: BoxFit.fitWidth,
                                height:
                                    MediaQuery.of(context).size.height - 300,
                                width: MediaQuery.of(context).size.width,
                              ),
                            ),
                          ),

                          /// Text Adder
                          for (int i = 0; i < provider.texts.length; i++)
                            Positioned(
                              top: provider.texts[i].yAxis,
                              left: provider.texts[i].xAxis,
                              child: provider.isTextAdderActive
                                  ? GestureDetector(
                                      onTap: () {
                                        provider.setSelectTextAdder(i);
                                      },
                                      child: Draggable<String>(
                                        data: 'Hello World',
                                        feedback: Material(
                                          color: Colors.transparent,
                                          child: Text(
                                            provider.texts[i].text.toString(),
                                            style: provider.texts[i].style,
                                          ),
                                        ),
                                        childWhenDragging: Container(),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Text(
                                            provider.texts[i].text.toString(),
                                            style: provider.texts[i].style,
                                          ),
                                        ),
                                        onDragEnd: (details) {
                                          final renderBox = context
                                              .findRenderObject() as RenderBox;
                                          Offset position = renderBox
                                              .globalToLocal(details.offset);
                                          provider.changeTextAdderPosition(
                                            i,
                                            position.dx,
                                            position.dy - 106,
                                          );
                                        },
                                      ),
                                    )
                                  : Material(
                                      color: Colors.transparent,
                                      child: Text(
                                        provider.texts[i].text.toString(),
                                        style: provider.texts[i].style,
                                      ),
                                    ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: Consumer<ImageEditorProvider>(
          builder: (context, provider, child) {
            if (provider.isPenActive) {
              if (provider.drawPoints.isEmpty) {
                return Container();
              }

              /// Sketch pen tool undo
              return FloatingActionButton(
                onPressed: () {
                  provider.undoPenSketchPoints();
                },
                child: const Icon(Icons.undo),
              );
            } else if (provider.isTextAdderActive) {
              /// Text Adder dialog
              return FloatingActionButton(
                onPressed: () async {
                  String value = await showDialog(
                    context: context,
                    builder: (context) => const TextAdderDialog(),
                  );
                  provider.addTextAdder(value);
                },
                child: const Icon(Icons.add),
              );
            }
            return Container();
          },
        ),
        bottomSheet: Card(
          elevation: 1,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Text Adder
                Consumer<ImageEditorProvider>(
                  builder: (context, provider, child) {
                    return IconButton(
                      onPressed: () {
                        if (provider.isTextAdderActive) {
                          provider.deActiveTextAdder();
                        } else {
                          provider.activeTextAdder();
                        }
                      },
                      icon: Icon(
                        Icons.text_fields,
                        color: provider.isTextAdderActive
                            ? Colors.blue
                            : Colors.grey,
                      ),
                    );
                  },
                ),

                /// Spacing
                const SizedBox(width: 20),

                /// Sketching Pen tool
                Consumer<ImageEditorProvider>(
                  builder: (context, provider, child) {
                    return IconButton(
                      onPressed: () {
                        if (provider.isPenActive) {
                          provider.deActiveSketchPen();
                        } else {
                          provider.activeSketchPen();
                        }
                      },
                      icon: Icon(
                        Icons.draw_outlined,
                        color: provider.isPenActive ? Colors.blue : Colors.grey,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
