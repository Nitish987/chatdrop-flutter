import 'package:chatdrop/modules/chat/presentation/controllers/ai_chat_controller.dart';
import 'package:chatdrop/shared/cubit/theme/theme_cubit.dart';
import 'package:chatdrop/shared/cubit/theme/theme_state.dart';
import 'package:chatdrop/modules/chat/data/models/message_model/ai_message_model.dart';
import 'package:chatdrop/shared/tools/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AiMessage extends StatefulWidget {
  final AiMessageModel message;
  final bool sameUser;
  final AiChatController chatController;
  final Function onSelect;

  const AiMessage({Key? key, required this.message, required this.sameUser, required this.chatController, required this.onSelect}): super(key: key);

  @override
  State<AiMessage> createState() => _AiMessageState();
}

class _AiMessageState extends State<AiMessage> {
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
            widget.message.content!,
            style: TextStyle(color: theme == ThemeState.light ? Colors.black: Colors.white),
          ),
          Text(
            _calTimeString(),
            style: TextStyle(
              color: theme == ThemeState.light ? Colors.grey : Colors.white,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );

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
      onDoubleTap: () {
        Clipboard.setData(ClipboardData(text: widget.message.content!));
        SuccessSnackBar.show(context, "Message Copied.");
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
