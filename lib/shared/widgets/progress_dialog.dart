import 'package:flutter/material.dart';

class ProgressDialog extends StatefulWidget {
  const ProgressDialog({super.key, this.title = 'Working on it', required this.label, required this.whileProgress});
  final String title, label;
  final Function whileProgress;

  @override
  State<ProgressDialog> createState() => _ProgressDialogState();
}

class _ProgressDialogState extends State<ProgressDialog> {
  @override
  void initState() {
    widget.whileProgress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 35,
            height: 35,
            child: CircularProgressIndicator(),
          ),
          const SizedBox(width: 20),
          Text(widget.label),
        ],
      ),
    );
  }
}
