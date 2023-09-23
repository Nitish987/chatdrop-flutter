import 'package:chatdrop/modules/auth/presentation/bloc/change_names/change_names_bloc.dart';
import 'package:chatdrop/modules/auth/presentation/bloc/change_names/change_names_event.dart';
import 'package:chatdrop/modules/auth/presentation/bloc/change_names/change_names_state.dart';
import 'package:chatdrop/shared/models/full_profile_model/full_profile_model.dart';
import 'package:chatdrop/shared/bloc/profile/profile_bloc.dart';
import 'package:chatdrop/shared/bloc/profile/profile_event.dart';
import 'package:chatdrop/shared/tools/snackbar_message.dart';
import 'package:chatdrop/shared/widgets/appbar_title.dart';
import 'package:chatdrop/shared/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeNamesPage extends StatefulWidget {
  const ChangeNamesPage({super.key, required this.profileModel});

  final FullProfileModel profileModel;

  @override
  State<ChangeNamesPage> createState() => _ChangeNamesPageState();
}

class _ChangeNamesPageState extends State<ChangeNamesPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late bool areFieldChanged = false;

  @override
  void initState() {
    List<String> name = widget.profileModel.profile!.name!.split(' ');
    _firstNameController.text = name[0];
    _lastNameController.text = name[1];
    _usernameController.text = widget.profileModel.profile!.username!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'Name & Username'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _firstNameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      hintText: 'First Name',
                      prefixIcon: Icon(Icons.person_2_outlined),
                    ),
                    onChanged: (value) {
                      setState(() {
                        areFieldChanged = true;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _lastNameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      hintText: 'Last Name',
                      prefixIcon: Icon(Icons.person_2_outlined),
                    ),
                    onChanged: (value) {
                      setState(() {
                        areFieldChanged = true;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      hintText: 'Username',
                      prefixIcon: Icon(Icons.person_2_outlined),
                    ),
                    onChanged: (value) {
                      setState(() {
                        areFieldChanged = true;
                      });
                    },
                  ),
                  const SizedBox(height: 40),
                  if (areFieldChanged)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text("Verify it's you", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.password_outlined),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            BlocConsumer<ChangeNamesBloc, ChangeNamesState>(
              builder: (context, state) {
                if (state is LoadingChangeState) {
                  return const Loading();
                }

                if (areFieldChanged || state is FailedChangeNamesState) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                    child: const Text(
                      'Apply',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      BlocProvider.of<ChangeNamesBloc>(context).add(
                        UpdateNamesEvent(
                          firstName: _firstNameController.value.text,
                          lastName: _lastNameController.value.text,
                          username: _usernameController.value.text,
                          password: _passwordController.value.text,
                        ),
                      );
                    },
                  );
                }

                return Container();
              },
              listener: (context, state) {
                if (state is FailedChangeNamesState) {
                  ErrorSnackBar.show(context, state.error);
                } else if (state is SuccessChangeNamesState) {
                  BlocProvider.of<ProfileBloc>(context).add(
                    ProfileUpdateNamesEvent(
                      widget.profileModel,
                      name: '${_firstNameController.value.text} ${_lastNameController.value.text}',
                      username: _usernameController.value.text,
                    ),
                  );
                  SuccessSnackBar.show(context, 'Names Updated.');
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
