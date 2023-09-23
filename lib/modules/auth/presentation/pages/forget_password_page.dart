import 'package:chatdrop/settings/constants/chatdrop_constant.dart';
import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/shared/cubit/theme/theme_cubit.dart';
import 'package:chatdrop/shared/cubit/theme/theme_state.dart';
import 'package:chatdrop/shared/tools/web_visit.dart';
import 'package:chatdrop/shared/widgets/logo_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../bloc/forget_password/forget_password_bloc.dart';
import '../bloc/forget_password/forget_password_event.dart';
import '../bloc/forget_password/forget_password_state.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  late ThemeState theme;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    theme = BlocProvider.of<ThemeCubit>(context).state;
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
                    'Forget Password',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 15),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child:
                        BlocConsumer<ForgetPasswordBloc, ForgetPasswordState>(
                      builder: (context, state) {
                        if (state is ForgetPasswordInitialState) {
                          return Column(
                            children: [
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  hintText: 'Email',
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                              ),
                              const SizedBox(height: 30),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(50)),
                                child: const Text(
                                  'I forget my password',
                                  style: TextStyle(fontSize: 20),
                                ),
                                onPressed: () {
                                  BlocProvider.of<ForgetPasswordBloc>(context)
                                      .add(
                                    ForgetPasswordEmailSubmitEvent(
                                      _emailController.value.text,
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        } else if (state is ForgetPasswordEmailSuccessState) {
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
                                    BlocProvider.of<ForgetPasswordBloc>(context)
                                        .add(
                                      ForgetPasswordResentOtpEvent(
                                        proToken: state.proToken,
                                        prrToken: state.prrToken,
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
                                  BlocProvider.of<ForgetPasswordBloc>(context)
                                      .add(
                                    ForgetPasswordVerificationEvent(
                                      otp: _otpController.value.text,
                                      proToken: state.proToken,
                                      prrToken: state.prrToken,
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        } else if (state
                            is ForgetPasswordVerificationSuccessState) {
                          return Column(
                            children: [
                              TextField(
                                controller: _passwordController,
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: const InputDecoration(
                                  hintText: 'New Password',
                                  prefixIcon: Icon(Icons.password),
                                ),
                              ),
                              const SizedBox(height: 30),
                              TextField(
                                controller: _rePasswordController,
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: const InputDecoration(
                                  hintText: 'Confirm Password',
                                  prefixIcon: Icon(Icons.password),
                                ),
                              ),
                              const SizedBox(height: 30),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(50)),
                                child: const Text(
                                  'Change Password',
                                  style: TextStyle(fontSize: 20),
                                ),
                                onPressed: () {
                                  BlocProvider.of<ForgetPasswordBloc>(context)
                                      .add(
                                    NewPasswordSubmitEvent(
                                      password: _passwordController.value.text,
                                      rePassword:
                                          _rePasswordController.value.text,
                                      prnpToken: state.prnpToken,
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        } else {
                          return const SpinKitWave(
                            color: Colors.blue,
                            size: 20.0,
                          );
                        }
                      },
                      listener: (context, state) {
                        if (state is ForgetPasswordFailedState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                state.error,
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (state is ForgetPasswordEmailSuccessState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                state.message,
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else if (state is ForgetPasswordSuccessState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                state.message,
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Future.delayed(const Duration(milliseconds: 1500),
                              () {
                            Navigator.pop(context);
                          });
                        }
                      },
                    )),
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
