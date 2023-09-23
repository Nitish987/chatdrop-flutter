import 'dart:convert';
import 'dart:io';

import 'package:chatdrop/infra/utilities/convert.dart';
import 'package:chatdrop/shared/controllers/secret_chat_controller.dart';
import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/shared/cubit/theme/theme_cubit.dart';
import 'package:chatdrop/shared/cubit/theme/theme_state.dart';
import 'package:chatdrop/shared/widgets/thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../shared/models/message_model/secret_message_model.dart';

class SecretMessage extends StatelessWidget {
  final SecretMessageModel message;
  final bool sameUser;
  final SecretChatController chatController;

  const SecretMessage({Key? key, required this.message, required this.sameUser, required this.chatController}): super(key: key);

  String _calTimeString() {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(message.time!);
    return DateFormat('hh:mm a').format(dateTime);
  }

  ImageProvider _getImageProviderAccordingly(
      SecretMessageContentModel messageContent) {
    if (messageContent.localContentPath != null) {
      File file = File(messageContent.localContentPath!);
      if (file.existsSync()) {
        return FileImage(File(file.path));
      }
    }
    final imageBytes = base64ToBytes(messageContent.content!);
    return MemoryImage(imageBytes);
  }

  @override
  Widget build(BuildContext context) {
    ThemeState theme = BlocProvider.of<ThemeCubit>(context).state;

    Color color;
    if(theme == ThemeState.light) {
      color = Colors.grey.shade200;
      if (sameUser) {
        color = const Color.fromRGBO(220, 248, 198, 100);
      }
    } else {
      color = Colors.grey.shade800;
      if (sameUser) {
        color = Colors.blue;
      }
    }

    Widget container;

    if (message.isDeleted!) {
      container = Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.all(10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          shape: BoxShape.rectangle,
        ),
        child: Column(
          crossAxisAlignment:
          sameUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              'This Message was Deleted',
              style: TextStyle(color: theme == ThemeState.light ? Colors.grey : Colors.white, fontStyle: FontStyle.italic),
            )
          ],
        ),
      );
    } else if (message.isInterrupted!) {
      container = Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.all(10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          shape: BoxShape.rectangle,
        ),
        child: Column(
          crossAxisAlignment:
          sameUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                chatController.interruptedMessageSignal(message.id!);
              },
              child: Text(
                'This Message was Interrupted. Tap to recover if your friend comes online or say to resend this message.',
                style: TextStyle(color: theme == ThemeState.light ? Colors.grey : Colors.white, fontStyle: FontStyle.italic),
              ),
            )
          ],
        ),
      );
    } else {
      /// extracting message content
      SecretMessageContentModel messageContent = SecretMessageContentModel.fromJson(jsonDecode(message.content!));

      if (message.contentType == 'IMAGE') {

        ImageProvider imageProvider = _getImageProviderAccordingly(messageContent);

        container = Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            shape: BoxShape.rectangle,
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () {
                    if (messageContent.localContentPath != null) {
                      Navigator.pushNamed(context, Routes.fileImageViewer, arguments: {
                        'path': messageContent.localContentPath,
                      });
                    }
                  },
                  child: Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.width * 0.6,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    width: 65,
                    child: Row(
                      children: [
                        Text(
                          _calTimeString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                        if (sameUser)
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Icon(
                              message.isRead! ? Icons.done_all : Icons.done,
                              color: theme == ThemeState.light ? null : Colors.black,
                              size: 15,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else if (message.contentType == 'VIDEO') {

        container = Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(10),
            shape: BoxShape.rectangle,
          ),
          child: Stack(
            children: [
              if (messageContent.localContentPath != null && File(messageContent.localContentPath!).existsSync())
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      if (messageContent.localContentPath != null) {
                        Navigator.pushNamed(context, Routes.fileVideoViewer, arguments: {
                          'path': messageContent.localContentPath,
                        });
                      }
                    },
                    child: Thumbnail.file(
                      source: messageContent.localContentPath!,
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.width * 0.6,
                    ),
                  ),
                ),
              const Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    width: 65,
                    child: Row(
                      children: [
                        Text(
                          _calTimeString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                        if (sameUser)
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Icon(
                              message.isRead! ? Icons.done_all : Icons.done,
                              color: theme == ThemeState.light ? null : Colors.black,
                              size: 15,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        container = Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          padding: const EdgeInsets.all(10),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            shape: BoxShape.rectangle,
          ),
          child: Column(
            crossAxisAlignment: sameUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                messageContent.text.toString(),
                style: TextStyle(color: theme == ThemeState.light ? Colors.black: Colors.white),
              ),
              SizedBox(
                width: 65,
                child: Row(
                  mainAxisAlignment: sameUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Text(
                      _calTimeString(),
                      style: TextStyle(
                        color: theme == ThemeState.light ? Colors.grey : Colors.white,
                        fontSize: 10,
                      ),
                    ),
                    if (sameUser)
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Icon(
                          message.isRead! ? Icons.done_all : Icons.done,
                          color: theme == ThemeState.light ? null : Colors.black,
                          size: 15,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    }

    return Align(
      alignment: sameUser ? Alignment.centerRight : Alignment.centerLeft,
      child: container,
    );
  }
}
