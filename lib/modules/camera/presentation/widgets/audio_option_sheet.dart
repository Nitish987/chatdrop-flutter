import 'package:chatdrop/shared/widgets/bottom_sheet_container.dart';
import 'package:chatdrop/shared/widgets/option.dart';
import 'package:flutter/material.dart';

class AudioOptionSheet extends StatelessWidget {
  const AudioOptionSheet(
      {Key? key,
        required this.sameUser,
        required this.onDelete,
        required this.onReport})
      : super(key: key);
  final bool sameUser;
  final Function onDelete;
  final Function onReport;

  @override
  Widget build(BuildContext context) {
    return BottomSheetContainer(
      padding: const EdgeInsets.all(10),
      height: 250,
      children: [
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
