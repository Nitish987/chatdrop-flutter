import 'package:chatdrop/modules/auth/presentation/bloc/change_password/change_password_bloc.dart';
import 'package:chatdrop/modules/auth/presentation/bloc/change_password/change_password_event.dart';
import 'package:chatdrop/modules/auth/presentation/bloc/change_password/change_password_state.dart';
import 'package:chatdrop/shared/tools/snackbar_message.dart';
import 'package:chatdrop/shared/widgets/appbar_title.dart';
import 'package:chatdrop/shared/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _reNewPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'Change Password'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Change Password',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _currentPasswordController,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: const InputDecoration(
                      hintText: 'Current Password',
                      prefixIcon: Icon(Icons.password_outlined),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _newPasswordController,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: const InputDecoration(
                      hintText: 'New Password',
                      prefixIcon: Icon(Icons.password_outlined),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _reNewPasswordController,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: const InputDecoration(
                      hintText: 'Confirm New Password',
                      prefixIcon: Icon(Icons.password_outlined),
                    ),
                  ),
                ],
              ),
            ),
            BlocConsumer<PasswordChangeBloc, PasswordChangeState>(
              builder: (context, state) {
                if (state is InitialPasswordChangeState || state is FailedPasswordChangeState) {
                  return ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<PasswordChangeBloc>(context).add(PasswordChangeRequestEvent(
                          _currentPasswordController.value.text,
                          _newPasswordController.value.text,
                          _reNewPasswordController.value.text,
                      ));
                    },
                    child: const Text('Change Password'),
                  );
                }
                return const Loading();
              },
              listener: (context, state) {
                if (state is FailedPasswordChangeState) {
                  ErrorSnackBar.show(context, state.error);
                } else if (state is SuccessPasswordChangeState) {
                  SuccessSnackBar.show(context, state.message);

                  Future.delayed(const Duration(milliseconds: 500), () {
                    Navigator.pop(context);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
