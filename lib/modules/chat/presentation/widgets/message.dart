import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatdrop/shared/controllers/normal_chat_controller.dart';
import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/shared/cubit/theme/theme_cubit.dart';
import 'package:chatdrop/shared/cubit/theme/theme_state.dart';
import 'package:chatdrop/shared/models/message_model/message_model.dart';
import 'package:chatdrop/shared/models/post_model/post_model.dart';
import 'package:chatdrop/shared/models/reel_model/reel_model.dart';
import 'package:chatdrop/shared/widgets/messages.dart';
import 'package:chatdrop/shared/widgets/thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class Message extends StatefulWidget {
  final MessageModel message;
  final bool sameUser;
  final NormalChatController chatController;
  final Function onSelect;

  const Message({Key? key, required this.message, required this.sameUser, required this.chatController, required this.onSelect}): super(key: key);

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  String _calTimeString() {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(widget.message.time!);
    return DateFormat('hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    ThemeState theme = BlocProvider.of<ThemeCubit>(context).state;

    Color color;
    if(theme == ThemeState.light) {
      color = Colors.grey.shade200;
      if (widget.sameUser) {
        color = const Color.fromRGBO(220, 248, 198, 100);
      }
    } else {
      color = Colors.grey.shade800;
      if (widget.sameUser) {
        color = Colors.blue;
      }
    }

    Widget container;

    if (widget.message.isDeleted!) {
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
          crossAxisAlignment: widget.sameUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              'This Message was Deleted',
              style: TextStyle(color: theme == ThemeState.light ? Colors.grey : Colors.white, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      );
    } else {
      /// extracting message content
      String content = widget.chatController.decryptContent(widget.message.content!);

      if (widget.message.contentType == 'IMAGE') {

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
                    Navigator.pushNamed(context, Routes.webImageViewer, arguments: {
                      'source': content,
                    });
                  },
                  child: CachedNetworkImage(
                    imageUrl: content,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.width * 0.6,
                    placeholder: (context, value) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.width * 0.6,
                        color: Colors.grey,
                      );
                    },
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          _calTimeString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                        if (widget.sameUser)
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Icon(
                              widget.message.isRead! ? Icons.done_all : Icons.done,
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
      } else if (widget.message.contentType == 'VIDEO') {

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
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.webVideoViewer, arguments: {
                      'source': content,
                    });
                  },
                  child: Thumbnail.network(
                    source: content,
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          _calTimeString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                        if (widget.sameUser)
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Icon(
                              widget.message.isRead! ? Icons.done_all : Icons.done,
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
      } else if (widget.message.contentType == 'POST') {

        container = Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            shape: BoxShape.rectangle,
          ),
          child: FutureBuilder(
            future: widget.chatController.retrievePostMessage(widget.message.refer!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(10),
                  child: CenterMessage(message: 'Loading...'),
                );
              }

              if (snapshot.hasError || !snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.all(10),
                  child: CenterMessage(message: 'This post has been removed or you have no permission to view it.'),
                );
              }

              PostModel post = snapshot.data!;

              Widget postLowerCard = Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 50,
                  color: const Color.fromRGBO(255, 255, 255, 200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (post.contentType == 'TEXT')
                        Text(
                          'Post by ${post.user!.name}',
                          style: TextStyle(
                            color: theme == ThemeState.light ? Colors.black : Colors.white,
                          ),
                        )
                      else
                        Text(
                          'Post by ${post.user!.name}',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      if (post.contentType == 'TEXT')
                        Align(
                          alignment: Alignment.bottomRight,
                          child: SizedBox(
                            width: 65,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  _calTimeString(),
                                  style: TextStyle(
                                    color: theme == ThemeState.light ? Colors.black : Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                                if (widget.sameUser)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Icon(
                                      widget.message.isRead! ? Icons.done_all : Icons.done,
                                      color: theme == ThemeState.light ? null : Colors.black,
                                      size: 15,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )
                      else
                        Align(
                          alignment: Alignment.bottomRight,
                          child: SizedBox(
                            width: 65,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  _calTimeString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                                if (widget.sameUser)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Icon(
                                      widget.message.isRead! ? Icons.done_all : Icons.done,
                                      color: theme == ThemeState.light ? null : Colors.black,
                                      size: 15,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );

              Widget child;
              if (post.contentType == 'PHOTO' || post.contentType == 'TEXT_PHOTO') {
                child = Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: post.photos![0].url!,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.width * 0.6,
                      placeholder: (context, value) {
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.width * 0.6,
                          color: Colors.grey,
                        );
                      },
                    ),
                    postLowerCard,
                  ],
                );
              } else if (post.contentType == 'VIDEO' || post.contentType == 'TEXT_VIDEO'){
                child = Stack(
                  children: [
                    Thumbnail.network(
                      source: post.video!.url!,
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.width * 0.6,
                    ),
                    postLowerCard,
                  ],
                );
              } else {
                child = Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        post.text!,
                        style: TextStyle(color: theme == ThemeState.light ? Colors.black: Colors.white),
                      ),
                    ),
                    postLowerCard,
                  ],
                );
              }

              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.postShowcase, arguments: {
                      'post': post,
                      'same_user': post.user!.uid == post.authUser!.uid,
                      'post_visibility_cubit': null,
                      'post_like_cubit': null,
                      'post_delete_cubit': null,
                    });},
                  child: child,
                ),
              );
            },
          ),
        );
      } else if (widget.message.contentType == 'STORY') {
        container = Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            shape: BoxShape.rectangle,
          ),
          child: Column(
            crossAxisAlignment: widget.sameUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Story Reply',
                  style: TextStyle(
                    color: theme == ThemeState.light ? Colors.black: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.all(5),
                width: (MediaQuery.of(context).size.width * 0.6) - 20,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 200),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Text(
                  content,
                  style: TextStyle(color: theme == ThemeState.light ? Colors.black: Colors.white),
                ),
              ),
              SizedBox(
                width: 65,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _calTimeString(),
                      style: TextStyle(
                        color: theme == ThemeState.light ? Colors.grey : Colors.white,
                        fontSize: 10,
                      ),
                    ),
                    if (widget.sameUser)
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Icon(
                          widget.message.isRead! ? Icons.done_all : Icons.done,
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
      } else if (widget.message.contentType == 'REEL') {

        container = Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            shape: BoxShape.rectangle,
          ),
          child: FutureBuilder(
            future: widget.chatController.retrieveReelMessage(widget.message.refer!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(10),
                  child: CenterMessage(message: 'Loading...'),
                );
              }

              if (snapshot.hasError || !snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.all(10),
                  child: CenterMessage(message: 'This reel has been removed or you have no permission to view it.'),
                );
              }

              ReelModel reel = snapshot.data!;

              Widget postLowerCard = Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 50,
                  color: const Color.fromRGBO(255, 255, 255, 200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Reel by ${reel.user!.name}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: SizedBox(
                          width: 65,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                _calTimeString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                              if (widget.sameUser)
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Icon(
                                    widget.message.isRead! ? Icons.done_all : Icons.done,
                                    color: theme == ThemeState.light ? null : Colors.black,
                                    size: 15,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );

              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.reelShowcase, arguments: {
                      'reel': reel,
                      'same_user': reel.user!.uid == reel.authUser!.uid,
                    });
                  },
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: reel.video!.thumbnail!,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.width * 0.6,
                        placeholder: (context, value) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: MediaQuery.of(context).size.width * 0.6,
                            color: Colors.grey,
                          );
                        },
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.video_camera_back_outlined, color: Colors.white),
                      ),
                      postLowerCard,
                    ],
                  ),
                ),
              );
            },
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
            crossAxisAlignment:
            widget.sameUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                content,
                style: TextStyle(color: theme == ThemeState.light ? Colors.black: Colors.white),
              ),
              SizedBox(
                width: 65,
                child: Row(
                  mainAxisAlignment: widget.sameUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Text(
                      _calTimeString(),
                      style: TextStyle(
                        color: theme == ThemeState.light ? Colors.grey : Colors.white,
                        fontSize: 10,
                      ),
                    ),
                    if (widget.sameUser)
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Icon(
                          widget.message.isRead! ? Icons.done_all : Icons.done,
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

    return GestureDetector(
      onLongPress: () {
        setState(() {
          if (widget.message.isSelected!) {
            widget.message.isSelected = false;
            widget.chatController.selectedMessages.remove(widget.message);
          } else {
            widget.message.isSelected = true;
            widget.chatController.selectedMessages.add(widget.message);
          }
          widget.onSelect(widget.message.isSelected);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.message.isSelected! ? theme == ThemeState.light ? Colors.blue.shade50 : Colors.grey.shade900 : null,
        ),
        child: Align(
          alignment: widget.sameUser ? Alignment.centerRight : Alignment.centerLeft,
          child: container,
        ),
      ),
    );
  }
}
