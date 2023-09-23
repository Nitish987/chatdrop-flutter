import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/shared/widgets/bottom_sheet_container.dart';
import 'package:chatdrop/shared/widgets/option.dart';
import 'package:flutter/material.dart';

class AddBottomSheet extends StatelessWidget {
  const AddBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetContainer(
      height: 220,
      children: [
        Option(
          label: 'Add Post',
          icon: Icons.post_add_outlined,
          color: Colors.red,
          onPressed: () {
            Navigator.popAndPushNamed(context, Routes.post, arguments: {
              'type': null,
              'file': null,
            });
          },
        ),
        Option(
          label: 'Add Story',
          icon: Icons.history_toggle_off,
          color: Colors.green,
          onPressed: () {
            Navigator.popAndPushNamed(context, Routes.storyConfig);
          },
        ),
        Option(
          label: 'Add Reel',
          icon: Icons.video_camera_back_outlined,
          color: Colors.blue,
          onPressed: () {
            Navigator.popAndPushNamed(context, Routes.reel, arguments: {
              'file': null,
              'audio': null,
            });
          },
        )
      ],
    );
  }
}
