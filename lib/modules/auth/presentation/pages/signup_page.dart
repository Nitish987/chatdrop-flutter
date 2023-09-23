import 'package:chatdrop/settings/constants/chatdrop_constant.dart';
import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/shared/cubit/auth/auth_cubit.dart';
import 'package:chatdrop/shared/cubit/theme/theme_cubit.dart';
import 'package:chatdrop/shared/cubit/theme/theme_state.dart';
import 'package:chatdrop/shared/tools/snackbar_message.dart';
import 'package:chatdrop/shared/tools/web_visit.dart';
import 'package:chatdrop/shared/widgets/loading.dart';
import 'package:chatdrop/shared/widgets/logo_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/signup/signup_bloc.dart';
import '../bloc/signup/signup_event.dart';
import '../bloc/signup/signup_state.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late ThemeState theme;
  final List<String> _genderList = ['Male', 'Female', 'Others'];
  late String _genderSelected = 'Select Gender';
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  late DateTime _dateOfBirth;

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2050),
    ).then((value) {
      setState(() {
        _dateOfBirth = value!;
      });
    });
  }

  @override
  void initState() {
    theme = BlocProvider.of<ThemeCubit>(context).state;
    setState(() {
      _genderSelected = _genderList.first;
      _dateOfBirth = DateTime.now();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overflow) {
            overflow.disallowIndicator();
            return false;
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 7),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme == ThemeState.light ? Colors.blueGrey.shade50 : Colors.grey.shade900,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: const LogoBar()),
                Image.asset('assets/images/connections.png'),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Signup',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BlocConsumer<SignupBloc, SignupState>(
                    builder: (context, state) {
                      if (state is SignupInitialState) {
                        return Column(
                          children: [
                            TextField(
                              controller: _firstNameController,
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                hintText: 'First Name',
                                prefixIcon: Icon(Icons.person_2_outlined),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: _lastNameController,
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                hintText: 'Last Name',
                                prefixIcon: Icon(Icons.person_2_outlined),
                              ),
                            ),
                            const SizedBox(height: 30),
                            ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton(
                                icon: const Icon(Icons.person_2_outlined),
                                value: _genderSelected,
                                underline: Container(
                                  height: 1.2,
                                  color: Colors.grey,
                                ),
                                isExpanded: true,
                                items: _genderList
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _genderSelected = value!;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 25),
                            InkWell(
                              onTap: _showDatePicker,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Icon(
                                          Icons.date_range_outlined,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        'Date of Birth - ${_dateOfBirth.day}-${_dateOfBirth.month}-${_dateOfBirth.year}',
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    height: 25,
                                    thickness: 1,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: const InputDecoration(
                                hintText: 'New Password',
                                prefixIcon: Icon(Icons.password_outlined),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: _rePasswordController,
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: const InputDecoration(
                                hintText: 'Confirm Password',
                                prefixIcon: Icon(Icons.password_outlined),
                              ),
                            ),
                            const SizedBox(height: 20),
                            InkWell(
                              child: const Text(
                                'By clicking signup, you agree to our terms and privacy policy.',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                              onTap: () {
                                webVisit(ChatdropConstant.termsUrl);
                              },
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50)),
                              child: const Text(
                                'Signup',
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                String day = _dateOfBirth.day.toString(), month = _dateOfBirth.month.toString();
                                if (_dateOfBirth.day < 10) day = '0${_dateOfBirth.day}';
                                if (_dateOfBirth.month < 10) month = '0${_dateOfBirth.month}';
                                BlocProvider.of<SignupBloc>(context).add(
                                  SignupDetailSubmitEvent(
                                    firstName: _firstNameController.value.text,
                                    lastName: _lastNameController.value.text,
                                    gender: _genderSelected,
                                    dateOfBirth: '$day-$month-${_dateOfBirth.year}',
                                    email: _emailController.value.text,
                                    password: _passwordController.value.text,
                                    rePassword: _rePasswordController.value.text,
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      } else if (state is SignupDetailSuccessState) {
                        return Column(
                          children: [
                            TextField(
                              controller: _otpController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'OTP',
                                prefixIcon: Icon(Icons.password),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                child: const Text(
                                  "Resent OTP",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                onTap: () {
                                  BlocProvider.of<SignupBloc>(context).add(
                                    SignupResentOtpEvent(
                                      soToken: state.soToken,
                                      srToken: state.srToken,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50)),
                              child: const Text(
                                'Verify Account',
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                BlocProvider.of<SignupBloc>(context).add(
                                  SignupVerificationEvent(
                                    otp: _otpController.value.text,
                                    soToken: state.soToken,
                                    srToken: state.srToken,
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      } else {
                        return const Loading();
                      }
                    },
                    listener: (context, state) {
                      if (state is SignupFailedState) {
                        ErrorSnackBar.show(context, state.error);
                      } else if (state is SignupDetailSuccessState) {
                        SuccessSnackBar.show(context, state.message);
                      } else if (state is SignupVerificationSuccessState) {
                        SuccessSnackBar.show(context, state.message);
                        Future.delayed(
                          const Duration(milliseconds: 1500),
                          () {
                            if (mounted) {
                              BlocProvider.of<AuthenticationCubit>(context).setAuthenticationState();
                              Navigator.pushReplacementNamed(
                                  context, Routes.dashboard);
                            }
                          },
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  child: const Center(
                    child: Text(
                      "Already have an account? Login here.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  onTap: () {
                    if (mounted) {
                      Navigator.pushReplacementNamed(context, Routes.login);
                    }
                  },
                ),
                const SizedBox(height: 40),
                InkWell(
                  child: const Center(
                    child: Text(
                      "Terms | Privacy",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  onTap: () {
                    webVisit(ChatdropConstant.privacyUrl);
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
