import 'package:chatdrop/shared/widgets/bottom_sheet_container.dart';
import 'package:chatdrop/shared/widgets/option.dart';
import 'package:flutter/material.dart';

class PostOptionSheet extends StatelessWidget {
  const PostOptionSheet(
      {Key? key,
      required this.sameUser,
      required this.onView,
      required this.onDelete,
      required this.onReport})
      : super(key: key);
  final bool sameUser;
  final Function onView;
  final Function onDelete;
  final Function onReport;

  @override
  Widget build(BuildContext context) {
    return BottomSheetContainer(
      children: [
        Option(
          label: 'View',
          icon: Icons.photo_size_select_large,
          color: Colors.blue,
          onPressed: () {
            onView();
            Navigator.pop(context);
          },
        ),
        if (sameUser)
          Option(
            label: 'Delete',
            icon: Icons.delete_outline,
            color: Colors.red,
            onPressed: () {
              onDelete();
              Navigator.pop(context);
            },
          ),
        Option(
          label: 'Report',
          icon: Icons.report_outlined,
          color: Colors.deepOrangeAccent,
          onPressed: () {
            onReport();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
