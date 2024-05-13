// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ptit_quiz_frontend/core/constants/data_key.dart';
import 'package:ptit_quiz_frontend/core/router/app_router.dart';
import 'package:ptit_quiz_frontend/di.dart';
import 'package:ptit_quiz_frontend/domain/entities/account.dart';
import 'package:ptit_quiz_frontend/domain/usecases/otp_password.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/app_bloc.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:ptit_quiz_frontend/presentation/screens/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import '../../../core/utils/validator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    // var Appstate = context.watch<ForgotPassWordState>();
    // indexselectedPage = Appstate.index;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            toastification.show(
              context: context,
              type: ToastificationType.error,
              style: ToastificationStyle.flatColored,
              title: const Text('Xin hãy thử lại'),
              // description: Text(state.message),
              alignment: Alignment.topRight,
              autoCloseDuration: const Duration(seconds: 3),
              showProgressBar: false,
            );
          });
        } else if (state is AuthStateForgotPassword) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            toastification.show(
              context: context,
              type: ToastificationType.success,
              style: ToastificationStyle.flatColored,
              title: const Text('OTP sent successfully'),
              description: const Text('Check your email to get OTP code'),
              alignment: Alignment.topRight,
              autoCloseDuration: const Duration(seconds: 3),
              showProgressBar: false,
            );
          });
          // Appstate.changeIndex(1);
        } else if (state is AuthStateOtpPassword) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            toastification.show(
              context: context,
              type: ToastificationType.success,
              style: ToastificationStyle.flatColored,
              title: const Text('OTP verified successfully'),
              // description: const Text('Check your email to get OTP code'),
              alignment: Alignment.topRight,
              autoCloseDuration: const Duration(seconds: 3),
              showProgressBar: false,
            );
          });
          // Appstate.changeIndex(2);
        } else if (state is AuthStateResetPassword) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            toastification.show(
              context: context,
              type: ToastificationType.success,
              style: ToastificationStyle.flatColored,
              title: const Text('Password reset successfully'),
              // description: const Text('Check your email to get OTP code'),
              alignment: Alignment.topRight,
              autoCloseDuration: const Duration(seconds: 3),
              showProgressBar: false,
            );
          });
          GoRouter.of(context).go('/login');
        }
      },
      builder: (context, state) {
        if (state is AuthStateForgotPassword) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: OtpPassword(),
          );
        } else if (state is AuthStateOtpPassword) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: resetPassword(tokenUser: state.tokenUser),
          );
        } else if (state is AuthStateLoading) {
          return const Center(
            child: AppLoadingAnimation(),
          );
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            body: ForgotPassword(),
          );
        }
      },
    );
  }
}

final TextEditingController _emailController = TextEditingController();
final TextEditingController _otpController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final TextEditingController _confirmPasswordController =
    TextEditingController();
final TextEditingController _tokenUserController = TextEditingController();

final FocusNode _emailFocus = FocusNode();
final FocusNode _otpFocus = FocusNode();
final FocusNode _passwordFocus = FocusNode();
final FocusNode _confirmPasswordFocus = FocusNode();

String appTitle = 'Forgot Password';
String? emailError;
String? passwordError;
bool _passwordVisible = false;

class ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var Appstate = context.watch<ForgotPassWordState>();
    var size = MediaQuery.of(context).size;
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state is AuthStateError) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          toastification.show(
            context: context,
            type: ToastificationType.error,
            style: ToastificationStyle.flatColored,
            title: const Text('Send OTP failed'),
            // description: Text(state.message),
            alignment: Alignment.topRight,
            autoCloseDuration: const Duration(seconds: 3),
            showProgressBar: false,
          );
        });
      } else if (state is AuthStateForgotPassword) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          toastification.show(
            context: context,
            type: ToastificationType.success,
            style: ToastificationStyle.flatColored,
            title: const Text('Get OTP success'),
            description: const Text('Check your email to get OTP code'),
            alignment: Alignment.topRight,
            autoCloseDuration: const Duration(seconds: 3),
            showProgressBar: false,
          );
        });
        // Appstate.changeIndex(1);
      }
    }, builder: (context, state) {
      return Stack(
        children: [
          SingleChildScrollView(
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      constraints:
                          BoxConstraints(maxWidth: 540, minHeight: size.height),
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            const PtitLogo(),
                            const SizedBox(height: 24),
                            Text(
                              appTitle,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 40),
                            AppTextField(
                              controller: _emailController,
                              focusNode: _emailFocus,
                              labelText: 'Email',
                              hintText: 'example@gmail.com',
                              errorText: emailError,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_) {
                                _emailFocus.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_emailFocus);
                              },
                            ),
                            const SizedBox(height: 20),
                            const SizedBox(
                                height: 20), // Add the 'const' keyword here
                            FilledButton(
                              onPressed: () {
                                if (_emailController.text.isEmpty) {
                                  emailError = 'Email is required';
                                } else if (Validator.isEmail(
                                        _emailController.text) ==
                                    'Invalid email') {
                                  emailError = 'Invalid email';
                                } else {
                                  emailError = null;
                                }
                                if (emailError == null) {
                                  BlocProvider.of<AuthBloc>(context).add(
                                      AuthForgotPasswordEvent(
                                          email: _emailController.text));
                                  // print(state);
                                }
                              },
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 30)),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  )),
                              child: const Text('Send OTP'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      );
    });
  }
}

class OtpPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var Appstate = context.watch<ForgotPassWordState>();
    var size = MediaQuery.of(context).size;
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state is AuthStateError) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          toastification.show(
            context: context,
            type: ToastificationType.error,
            style: ToastificationStyle.flatColored,
            title: const Text('Wrong OTP code'),
            // description: Text(state.message),
            alignment: Alignment.topRight,
            autoCloseDuration: const Duration(seconds: 3),
            showProgressBar: false,
          );
        });
      } else if (state is AuthStateOtpPassword) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          toastification.show(
            context: context,
            type: ToastificationType.success,
            style: ToastificationStyle.flatColored,
            title: const Text('Change your password'),
            // description: const Text('Check your email to get OTP code'),
            alignment: Alignment.topRight,
            autoCloseDuration: const Duration(seconds: 3),
            showProgressBar: false,
          );
        });
        // Appstate.changeIndex(2);
      }
    }, builder: (context, state) {
      return Stack(
        children: [
          SingleChildScrollView(
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      constraints:
                          BoxConstraints(maxWidth: 540, minHeight: size.height),
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            const PtitLogo(),
                            const SizedBox(height: 24),
                            Text(
                              appTitle,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 40),
                            AppTextField(
                              controller: _emailController,
                              focusNode: _emailFocus,
                              labelText: 'Email',
                              hintText: 'example@gmail.com',
                              errorText: emailError,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_) {
                                _emailFocus.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_emailFocus);
                              },
                            ),
                            const SizedBox(height: 20),
                            AppTextField(
                              controller: _otpController,
                              focusNode: _otpFocus,
                              labelText: 'OTP',
                              hintText: '123456',
                              // errorText: emailError,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_) {
                                _otpFocus.unfocus();
                                FocusScope.of(context).requestFocus(_otpFocus);
                              },
                            ),
                            const SizedBox(
                                height: 20), // Add the 'const' keyword here
                            FilledButton(
                              onPressed: () {
                                if (_emailController.text.isEmpty) {
                                  emailError = 'Email is required';
                                } else if (Validator.isEmail(
                                        _emailController.text) ==
                                    'Invalid email') {
                                  emailError = 'Invalid email';
                                } else {
                                  emailError = null;
                                }
                                if (emailError == null) {
                                  BlocProvider.of<AuthBloc>(context).add(
                                    AuthOtpPasswordEvent(
                                      email: _emailController.text,
                                      otp: _otpController.text,
                                    ),
                                  );
                                  print(state);
                                }
                              },
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 30)),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  )),
                              child: const Text('Next'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      );
    });
  }
}

class resetPassword extends StatelessWidget {
  final String tokenUser;
  const resetPassword({Key? key, required this.tokenUser}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state is AuthStateError) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          toastification.show(
            context: context,
            type: ToastificationType.error,
            style: ToastificationStyle.flatColored,
            title: const Text('Reset password failed'),
            // description: Text(state.message),
            alignment: Alignment.topRight,
            autoCloseDuration: const Duration(seconds: 3),
            showProgressBar: false,
          );
        });
      } else if (state is AuthStateResetPassword) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          toastification.show(
            context: context,
            type: ToastificationType.success,
            style: ToastificationStyle.flatColored,
            title: const Text('Reset password success'),
            // description: const Text('Check your email to get OTP code'),
            alignment: Alignment.topRight,
            autoCloseDuration: const Duration(seconds: 3),
            showProgressBar: false,
          );
        });
        GoRouter.of(context).go('/login');
      }
    }, builder: (context, state) {
      return Stack(
        children: [
          SingleChildScrollView(
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      constraints:
                          BoxConstraints(maxWidth: 540, minHeight: size.height),
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            const PtitLogo(),
                            const SizedBox(height: 24),
                            Text(
                              appTitle,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 40),
                            AppTextField(
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              labelText: 'Password',
                              hintText: '********',
                              errorText: passwordError,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_) {
                                _passwordFocus.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_passwordFocus);
                              },
                              obscureText: !_passwordVisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  _passwordVisible = !_passwordVisible;
                                  // setState(() {});
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            AppTextField(
                              controller: _confirmPasswordController,
                              focusNode: _confirmPasswordFocus,
                              labelText: 'Confirm Password',
                              hintText: '********',
                              errorText: passwordError,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_) {
                                _confirmPasswordFocus.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_confirmPasswordFocus);
                              },
                              obscureText: !_passwordVisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  _passwordVisible = !_passwordVisible;
                                  // setState(() {});
                                },
                              ),
                            ),
                            const SizedBox(
                                height: 20), // Add the 'const' keyword here
                            FilledButton(
                              onPressed: () {
                                if (_passwordController.text.isEmpty) {
                                  passwordError = 'Password is required';
                                } else if (_confirmPasswordController
                                    .text.isEmpty) {
                                  passwordError =
                                      'Confirm password is required';
                                } else if (_passwordController.text !=
                                    _confirmPasswordController.text) {
                                  passwordError =
                                      'Password and confirm password are not the same';
                                } else {
                                  passwordError = null;
                                }
                                if (passwordError == null) {
                                  BlocProvider.of<AuthBloc>(context).add(
                                      AuthResetPasswordEvent(
                                          tokenUser: tokenUser,
                                          password: _passwordController.text));
                                }
                              },
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 30)),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  )),
                              child: const Text('Reset Password'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      );
    });
  }
}
