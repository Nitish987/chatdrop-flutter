import 'package:chatdrop/shared/models/user_model/user_model.dart';
import 'package:flutter/material.dart';

import '../tools/avatar_image_provider.dart';

class FriendUserActionTile extends StatefulWidget {
  final UserModel user;
  final String label;
  final Function onAction;

  const FriendUserActionTile(
      {Key? key,
      required this.user,
      required this.label,
      required this.onAction})
      : super(key: key);

  @override
  State<FriendUserActionTile> createState() => _FriendUserActionTileState();
}

class _FriendUserActionTileState extends State<FriendUserActionTile> {
  bool _hasActionPerformed = false;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: Avatar.getAvatarProvider(
          widget.user.gender.toString(),
          widget.user.photo,
        ),
      ),
      title: Text(widget.user.name.toString()),
      subtitle: Text(widget.user.message.toString()),
      trailing: TextButton(
        onPressed: () {
          if (!_hasActionPerformed) {
            widget.onAction((bool isProcessing) {
              setState(() {
                _isProcessing = isProcessing;
              });
            });
            setState(() {
              _hasActionPerformed = true;
            });
          }
        },
        child: _isProcessing
            ? const SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                _hasActionPerformed ? 'Done' : widget.label,
                style: TextStyle(
                  color: _hasActionPerformed ? Colors.grey : null,
                ),
              ),
      ),
    );
  }
}
