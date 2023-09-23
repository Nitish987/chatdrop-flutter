import 'package:flutter/material.dart';

class TextAdderDialog extends StatefulWidget {
  const TextAdderDialog({Key? key}) : super(key: key);

  @override
  State<TextAdderDialog> createState() => _TextAdderDialogState();
}

class _TextAdderDialogState extends State<TextAdderDialog> {
  final TextEditingController _textController = TextEditingController();
  late int _textCharCount = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 240,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter your text',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: _textController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Text',
                prefixIcon: const Padding(
                  padding: EdgeInsetsDirectional.only(bottom: 25),
                  child: Icon(Icons.message_outlined),
                ),
                counterText: '${_textCharCount.toString()} / 100',
                counterStyle: (_textCharCount > 100)
                    ? const TextStyle(color: Colors.red)
                    : null,
              ),
              maxLines: 3,
              onChanged: (value) {
                setState(() {
                  _textCharCount = value.length;
                });
              },
            ),
            const SizedBox(height: 5),
            TextButton(
              onPressed: () {
                Navigator.pop(context, _textController.value.text);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
