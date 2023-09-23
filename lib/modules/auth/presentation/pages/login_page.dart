import 'package:chatdrop/settings/constants/assets_constant.dart';
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
import 'package:google_sign_in/google_sign_in.dart';
import '../bloc/login/login_bloc.dart';
import '../bloc/login/login_event.dart';
import '../bloc/login/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late ThemeState theme;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void changeState(String name) {
    BlocProvider.of<LoginBloc>(context).add(ProgressEvent(name));
  }

  void signInWithGoogle() async {
    try {
      changeState('loading');
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      final account = await googleSignIn.signIn();
      final auth = await account?.authentication;
      if (auth != null && auth.idToken != null && mounted) {
        BlocProvider.of<LoginBloc>(context).add(GoogleSignInCredentialsSubmitEvent(auth.idToken!));
      } else {
        ErrorSnackBar.show(context, 'Sign in Failed. Try using email and password');
        changeState('initial');
      }
    } catch (e) {
        ErrorSnackBar.show(context, 'Sign in Failed. Try using email and password');
        changeState('initial');
    }
  }

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
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme == ThemeState.light ? Colors.blueGrey.shade50 : Colors.grey.shade900,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const LogoBar()
                ),
                Image.asset('assets/images/connections.png'),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Login',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
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
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.password_outlined),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          child: const Text(
                            "Forget Password",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          onTap: () {
                            if (mounted) {
                              Navigator.of(context).pushNamed(Routes.forgetPassword);
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      BlocConsumer<LoginBloc, LoginState>(
                        builder: (context, state) {
                          if (state is LoginProgressState) {
                            return const Loading();
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ElevatedButton(
                                  child: const Text('Login', style: TextStyle(fontSize: 17)),
                                  onPressed: () {
                                    BlocProvider.of<LoginBloc>(context).add(
                                      LoginCredentialsSubmitEvent(
                                        _emailController.value.text,
                                        _passwordController.value.text,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                InkWell(
                                  child: const Center(
                                    child: Text(
                                      "Don't have an account? Signup here.",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    if(mounted) {
                                      Navigator.pushReplacementNamed(context, Routes.signup);
                                    }
                                  },
                                ),
                                const SizedBox(height: 5),
                                const Divider(),
                                const SizedBox(height: 5),
                                FilledButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateColor.resolveWith((states) {
                                      if (theme == ThemeState.dark) {
                                        return const Color.fromRGBO(66, 133, 244, 1);
                                      }
                                      return Colors.white;
                                    }),
                                    elevation: MaterialStateProperty.resolveWith((states) => 1),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        LogoAssets.google,
                                        width: 35,
                                        height: 35,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Sign in with Google',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: theme == ThemeState.dark ? Colors.white: const Color.fromRGBO(143, 149, 151, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    signInWithGoogle();
                                  },
                                ),
                              ],
                            );
                          }
                        },
                        listener: (context, state) {
                          if (state is LoginFailedState) {
                            ErrorSnackBar.show(context, state.error);
                          } else if (state is LoginSuccessState && mounted) {
                            BlocProvider.of<AuthenticationCubit>(context).setAuthenticationState();
                            Navigator.pushReplacementNamed(context, Routes.dashboard);
                          } else if (state is GSACState) {
                            Navigator.pushNamed(context, Routes.gsac, arguments: {
                              'gsact': state.gsacToken,
                              'id_token': state.idToken,
                            }).then((value) {
                              if (value == 'LOGGEDIN') {
                                BlocProvider.of<AuthenticationCubit>(context).setAuthenticationState();
                                Navigator.pushReplacementNamed(context, Routes.dashboard);
                              }
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 17),
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
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
