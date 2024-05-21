import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ptit_quiz_frontend/core/router/app_router.dart';
import 'package:ptit_quiz_frontend/domain/entities/account.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/app_bloc.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:ptit_quiz_frontend/presentation/screens/widgets/widgets.dart';
import 'package:toastification/toastification.dart';

import '../../../core/utils/validator.dart';
import '../../../domain/entities/profile.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _studentCodeController;
  late final TextEditingController _studentClassController;
  late final TextEditingController _dateofBirthController;
  late final TextEditingController _adressController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  late final FocusNode _nameFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _studentCodeFocusNode;
  late final FocusNode _studentClassFocusNode;
  late final FocusNode _dateofBirthFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _confirmPasswordFocusNode;
  late final FocusNode _adressFocusNode;

  String appTitle = 'Register to PTIT Quiz';
  bool _passwordVisible = false;
  String? nameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;
  bool canRegister = false;

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
                  title: const Text('Register failed'),
                  description: Text(state.message),
                  alignment: Alignment.topRight,
                  autoCloseDuration: const Duration(seconds: 4),
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
                  title: const Text('Register successfully'),
                  description: const Text('Welcome to PTIT Quiz'),
                  alignment: Alignment.topRight,
                  autoCloseDuration: const Duration(seconds: 4),
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
                                // maxWidth: 540, minHeight: size.height),
                                maxWidth: 650,
                                minHeight: size.height),
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
                                      controller: _nameController,
                                      focusNode: _nameFocusNode,
                                      labelText: 'Full Name',
                                      hintText: 'Dep trai la ten anh',
                                      errorText: nameError,
                                      prefixIconData: Icons.person_outline,
                                      keyboardType: TextInputType.name,
                                      textInputAction: TextInputAction.next,
                                      onSubmitted: (_) {
                                        _nameFocusNode.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(_emailFocusNode);
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: AppTextField(
                                            controller: _studentCodeController,
                                            focusNode: _studentCodeFocusNode,
                                            labelText: 'Student Code',
                                            hintText: 'B20DCCN001',
                                            // errorText: nameError,
                                            prefixIconData:
                                                Icons.person_outline,
                                            keyboardType: TextInputType.name,
                                            textInputAction:
                                                TextInputAction.next,
                                            onSubmitted: (_) {
                                              _studentCodeFocusNode.unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      _studentClassFocusNode);
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: AppTextField(
                                            controller: _studentClassController,
                                            focusNode: _studentClassFocusNode,
                                            labelText: 'Student Class',
                                            hintText: 'D21CQCN01-N',
                                            // errorText: nameError,
                                            prefixIconData:
                                                Icons.person_outline,
                                            keyboardType: TextInputType.name,
                                            textInputAction:
                                                TextInputAction.next,
                                            onSubmitted: (_) {
                                              _studentClassFocusNode.unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      _dateofBirthFocusNode);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: AppTextField(
                                            controller: _adressController,
                                            focusNode: _adressFocusNode,
                                            labelText: 'Adress',
                                            hintText: 'Ha Noi',
                                            // errorText: nameError,
                                            prefixIconData: Icons.home_outlined,
                                            keyboardType: TextInputType.name,
                                            textInputAction:
                                                TextInputAction.next,
                                            onSubmitted: (_) {
                                              _dateofBirthFocusNode.unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      _adressFocusNode);
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: AppTextField(
                                            controller: _dateofBirthController,
                                            focusNode: _dateofBirthFocusNode,
                                            labelText: 'Date of Birth',
                                            hintText: 'dd/mm/yyyy',
                                            // errorText: nameError,
                                            prefixIconData:
                                                Icons.person_outline,
                                            keyboardType: TextInputType.name,
                                            textInputAction:
                                                TextInputAction.next,
                                            onSubmitted: (_) {
                                              _dateofBirthFocusNode.unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      _dateofBirthFocusNode);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
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
                                    Row(
                                      children: [
                                        Expanded(
                                          child: AppTextField(
                                            controller: _passwordController,
                                            focusNode: _passwordFocusNode,
                                            labelText: 'Password',
                                            hintText: '********',
                                            errorText: passwordError,
                                            prefixIconData: Icons.lock_outline,
                                            suffixIcon: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 12),
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
                                            textInputAction:
                                                TextInputAction.next,
                                            onSubmitted: (_) {
                                              _passwordFocusNode.unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      _confirmPasswordFocusNode);
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: AppTextField(
                                            controller:
                                                _confirmPasswordController,
                                            focusNode:
                                                _confirmPasswordFocusNode,
                                            labelText: 'Confirm Password',
                                            hintText: '********',
                                            errorText: confirmPasswordError,
                                            prefixIconData: Icons.lock_outline,
                                            obscureText: true,
                                            textInputAction:
                                                TextInputAction.done,
                                            onSubmitted: (_) {
                                              _confirmPasswordFocusNode
                                                  .unfocus();
                                              register();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    FilledButton(
                                      onPressed: () => {register()},
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
                                              'Register',
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
                                    const DeviderWithText(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text('Already have an account?'),
                                        MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: GestureDetector(
                                            onTap: () {
                                              context.go(AppRoutes.login);
                                            },
                                            child: Text(
                                              ' Login here',
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
                                    const SizedBox(height: 10),
                                  ]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (state is AuthStateLoading) const AppLoadingAnimation(),
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
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _studentCodeController = TextEditingController();
    _studentClassController = TextEditingController();
    _dateofBirthController = TextEditingController();
    _adressController = TextEditingController();

    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
    _studentCodeFocusNode = FocusNode();
    _studentClassFocusNode = FocusNode();
    _dateofBirthFocusNode = FocusNode();
    _adressFocusNode = FocusNode();

    _nameController.addListener(() {
      setState(() {
        nameError = Validator.isName(_nameController.text);
        updateCanRegister();
      });
    });

    _emailController.addListener(() {
      setState(() {
        emailError = Validator.isEmail(_emailController.text);
        updateCanRegister();
      });
    });

    _passwordController.addListener(() {
      setState(() {
        passwordError = Validator.isPassword(_passwordController.text);
        updateCanRegister();
      });
    });

    _confirmPasswordController.addListener(() {
      setState(() {
        confirmPasswordError = Validator.isConfirmPassword(
          _passwordController.text,
          _confirmPasswordController.text,
        );
        updateCanRegister();
      });
    });
  }

  void updateCanRegister() {
    canRegister = nameError == null &&
        emailError == null &&
        passwordError == null &&
        confirmPasswordError == null &&
        _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _studentCodeController.text.isNotEmpty &&
        _studentClassController.text.isNotEmpty &&
        _dateofBirthController.text.isNotEmpty;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _studentCodeController.dispose();
    _studentClassController.dispose();
    _dateofBirthController.dispose();
    _adressController.dispose();

    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _studentCodeFocusNode.dispose();
    _studentClassFocusNode.dispose();
    _dateofBirthFocusNode.dispose();
    _adressFocusNode.dispose();
    super.dispose();
  }

  void register() {
    if (canRegister) {
      context.read<AuthBloc>().add(
            AuthRegisterEvent(
              account: Account(
                email: _emailController.text,
                password: _passwordController.text,
              ),
              profile: Profile(
                fullName: _nameController.text,
                email: _emailController.text,
                studentCode: _studentCodeController.text,
                studentClass: _studentClassController.text,
                dob: _dateofBirthController.text,
                address: _adressController.text,
              ),
            ),
          );
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        toastification.show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.flatColored,
          title: const Text('Register failed'),
          description: const Text('Please fill in all fields correctly'),
          alignment: Alignment.topRight,
          autoCloseDuration: const Duration(seconds: 3),
          showProgressBar: false,
        );
      });
    }
  }
}
