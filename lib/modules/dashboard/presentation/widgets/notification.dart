import 'package:chatdrop/modules/dashboard/presentation/controllers/notification_controller.dart';
import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/shared/models/notification_model/notification_model.dart';
import 'package:chatdrop/shared/models/post_model/post_model.dart';
import 'package:chatdrop/shared/models/reel_model/reel_model.dart';
import 'package:chatdrop/shared/tools/avatar_image_provider.dart';
import 'package:flutter/material.dart';

class NotificationView extends StatefulWidget {
  final NotificationModel model;
  const NotificationView({Key? key, required this.model}) : super(key: key);

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final NotificationController _controller = NotificationController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: Avatar.getAvatarProvider(
            widget.model.user!.gender!,
            widget.model.user!.photo,
          ),
        ),
        title: Text(widget.model.subject!),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.model.user!.name} ${widget.model.body!}',
              maxLines: 1,
              style: widget.model.isRead!
                  ? null
                  : const TextStyle(color: Colors.blue),
            ),
            const SizedBox(height: 5),
            Text(
              widget.model.time!,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        onTap: () async {
          _controller.setNotificationRead(widget.model.id!);
          if (widget.model.type! == 'POST' || widget.model.type! == 'POST_LIKE' || widget.model.type! == 'POST_COMMENT' || widget.model.type! == 'POST_COMMENT_LIKE') {
            if (widget.model.referContent != null) {
              PostModel post = PostModel.fromJson(widget.model.referContent!);
              await Navigator.pushNamed(context, Routes.postShowcase, arguments: {
                'post': post,
                'same_user': post.user!.uid == post.authUser!.uid,
                'post_visibility_cubit': null,
                'post_like_cubit': null,
                'post_delete_cubit': null,
              });
            }
          } else if (widget.model.type! == 'REEL' || widget.model.type! == 'REEL_LIKE' || widget.model.type! == 'REEL_COMMENT' || widget.model.type! == 'REEL_COMMENT_LIKE') {
            ReelModel reel = ReelModel.fromJson(widget.model.referContent!);
            await Navigator.pushNamed(context, Routes.reelShowcase, arguments: {
              'reel': reel,
              'same_user': reel.user!.uid == reel.authUser!.uid,
            });
          } else {
            await Navigator.pushNamed(context, Routes.friendProfile, arguments: {
              'uid': widget.model.user!.uid
            });
          }
          setState(() {
            widget.model.isRead = true;
          });
        },
      ),
    );
  }
}
