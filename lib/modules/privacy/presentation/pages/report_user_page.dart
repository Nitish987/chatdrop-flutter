import 'package:chatdrop/modules/privacy/presentation/controllers/report_user_controller.dart';
import 'package:chatdrop/shared/tools/snackbar_message.dart';
import 'package:chatdrop/shared/widgets/appbar_title.dart';
import 'package:flutter/material.dart';

class ReportUserPage extends StatefulWidget {
  final String uid;

  const ReportUserPage({Key? key, required this.uid}) : super(key: key);

  @override
  State<ReportUserPage> createState() => _ReportUserPageState();
}

class _ReportUserPageState extends State<ReportUserPage> {
  final TextEditingController _reportMessageController = TextEditingController();
  final ReportUserController _reportUserController = ReportUserController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'Report User'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Report Message',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              flex: 1,
              child: TextField(
                controller: _reportMessageController,
                keyboardType: TextInputType.text,
                maxLines: 10,
                decoration: const InputDecoration(
                  hintText: 'Why you want to report',
                  prefixIcon: Padding(
                    padding: EdgeInsetsDirectional.only(bottom: 190),
                    child: Icon(Icons.message_outlined),
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _reportUserController.report(widget.uid, _reportMessageController.value.text);
                if (mounted) {
                  SuccessSnackBar.show(context, 'Report sent');
                  Navigator.pop(context);
                }
              },
              child: const Text('Report'),
            ),
          ],
        ),
      ),
    );
  }
}
