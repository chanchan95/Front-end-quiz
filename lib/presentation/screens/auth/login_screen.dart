import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ptit_quiz_frontend/core/constants/data_key.dart';
import 'package:ptit_quiz_frontend/core/router/app_router.dart';
import 'package:ptit_quiz_frontend/di.dart';
import 'package:ptit_quiz_frontend/domain/entities/account.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/app_bloc.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:ptit_quiz_frontend/presentation/screens/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import '../../../core/utils/validator.dart';

class LoginScreen extends StatefulWidget {
  final bool isAdmin;
  const LoginScreen({super.key, this.isAdmin = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  String appTitle = 'Sign in to PTIT Quiz';
  String? emailError;
  String? passwordError;
  bool canLogin = false;
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthStateError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                toastification.show(
                  context: context,
                  type: ToastificationType.error,
                  style: ToastificationStyle.flatColored,
                  title: const Text('Login failed'),
                  description: Text(state.message),
                  alignment: Alignment.topRight,
                  autoCloseDuration: const Duration(seconds: 3),
                  showProgressBar: false,
                );
              });
            } else if (state is AuthStateAuthenticated ||
                state is AuthStateAdminAuthenticated) {
              if (state is AuthStateAuthenticated) {
                context.go(AppRoutes.home);
              } else if (state is AuthStateAdminAuthenticated) {
                context.go(AppRoutes.adminStatistics);
              }
              WidgetsBinding.instance.addPostFrameCallback((_) {
                toastification.show(
                  context: context,
                  type: ToastificationType.success,
                  style: ToastificationStyle.flatColored,
                  title: const Text('Login successful'),
                  description: const Text('Welcome to PTIT Quiz'),
                  alignment: Alignment.topRight,
                  autoCloseDuration: const Duration(seconds: 3),
                  showProgressBar: false,
                );
              });
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 540, minHeight: size.height),
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
                                      focusNode: _emailFocusNode,
                                      labelText: 'Email',
                                      hintText: 'example@gmail.com',
                                      errorText: emailError,
                                      prefixIconData: Icons.email_outlined,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      onSubmitted: (_) {
                                        _emailFocusNode.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(_passwordFocusNode);
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    AppTextField(
                                      controller: _passwordController,
                                      focusNode: _passwordFocusNode,
                                      labelText: 'Password',
                                      hintText: '********',
                                      errorText: passwordError,
                                      prefixIconData: Icons.lock_outline,
                                      suffixIcon: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 12),
                                        child: IconButton(
                                          icon: Icon(
                                            _passwordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _passwordVisible =
                                                  !_passwordVisible;
                                            });
                                          },
                                        ),
                                      ),
                                      obscureText: !_passwordVisible,
                                      textInputAction: TextInputAction.done,
                                      onSubmitted: (_) {
                                        _passwordFocusNode.unfocus();
                                        login();
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    if (!widget.isAdmin)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: GestureDetector(
                                              onTap: () {
                                                context.go(
                                                    AppRoutes.forgotPassword);
                                              },
                                              child: Text(
                                                'Forgot password?',
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    const SizedBox(height: 20),
                                    FilledButton(
                                      onPressed: login,
                                      style: FilledButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Center(
                                            child: Text(
                                              'Login',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    if (!widget.isAdmin)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text('Don\'t have an account?'),
                                          MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: GestureDetector(
                                              onTap: () {
                                                context.go(AppRoutes.register);
                                              },
                                              child: Text(
                                                ' Register here',
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    const DeviderWithText(),
                                    Flex(
                                      direction: size.width > 800
                                          ? Axis.horizontal
                                          : Axis.vertical,
                                      children: [
                                        if (size.width > 800)
                                          const Expanded(child: SizedBox())
                                        else
                                          const SizedBox(height: 20),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Login as:',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            OutlinedButtonIcon(
                                              onPressed: () {
                                                context.go(
                                                  widget.isAdmin
                                                      ? AppRoutes.login
                                                      : AppRoutes.adminLogin,
                                                );
                                              },
                                              icon: widget.isAdmin
                                                  ? Icons.person_outline
                                                  : Icons
                                                      .admin_panel_settings_outlined,
                                              label: widget.isAdmin
                                                  ? 'User'
                                                  : 'Admin',
                                              color: widget.isAdmin
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .secondary
                                                  : Colors.black,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                  ]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (state is AuthStateLoading) const AppLoadingAnimation()
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _passwordVisible = false;

    if (widget.isAdmin) {
      appTitle = 'Sign in to PTIT Quiz as Admin';
    }

    final emailCached = getCachedEmail();
    if (emailCached != null) {
      _emailController.text = emailCached;
    }

    _emailController.addListener(() {
      final email = _emailController.text;
      setState(() {
        emailError = Validator.isEmail(email);
        updateLoginState();
      });
    });

    _passwordController.addListener(() {
      final password = _passwordController.text;
      setState(() {
        passwordError = Validator.isPassword(password);
        updateLoginState();
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  String? getCachedEmail() {
    return DependencyInjection.sl<SharedPreferences>().getString(DataKey.email);
  }

  void updateLoginState() {
    canLogin = emailError == null &&
        passwordError == null &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

  void login() {
    if (canLogin) {
      final email = _emailController.text;
      final password = _passwordController.text;

      if (emailError == null && passwordError == null) {
        DependencyInjection.sl<SharedPreferences>()
            .setString(DataKey.email, email);
      }

      if (widget.isAdmin) {
        context.read<AuthBloc>().add(AuthAdminLoginEvent(
              account: Account(
                email: email,
                password: password,
              ),
            ));
      } else {
        context.read<AuthBloc>().add(AuthLoginEvent(
              account: Account(
                email: email,
                password: password,
              ),
            ));
      }
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        toastification.show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.flatColored,
          title: const Text('Email or password are incorrect'),
          description: const Text('Please re-enter your email and password'),
          alignment: Alignment.topRight,
          autoCloseDuration: const Duration(seconds: 3),
          showProgressBar: false,
        );
      });
    }
  }
}
