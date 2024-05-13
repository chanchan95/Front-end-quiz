import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_quiz_frontend/domain/entities/profile.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/cubits/user_profile_cubit.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/user_profile_bloc/user_profile_bloc.dart';

class MannageUserDialog extends StatefulWidget {
  const MannageUserDialog({Key? key, required this.isEdit}) : super(key: key);

  final bool isEdit;

  @override
  State<MannageUserDialog> createState() => _MannageUserDialogState();
}

class _MannageUserDialogState extends State<MannageUserDialog> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isEdit ? 'Edit User' : 'Create User'),
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'User Details'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            UserDetailsTab(isEdit: widget.isEdit),
          ],
        ),
      ),
    );
  }
}

class UserDetailsTab extends StatefulWidget {
  const UserDetailsTab({Key? key, required this.isEdit});
  final bool isEdit;
  @override
  State<UserDetailsTab> createState() => _UserDetailsTabState();
}

class _UserDetailsTabState extends State<UserDetailsTab> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _studentCodeController = TextEditingController();
  final TextEditingController _studentClassController = TextEditingController();
  final TextEditingController _dateofBirthController = TextEditingController();
  final TextEditingController _adressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String status = 'active';
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 200,
        minWidth: 500,
      ),
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            if (widget.isEdit == false) ...[
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 16),
            ],
            TextField(
              controller: _studentCodeController,
              decoration: const InputDecoration(labelText: 'Student Code'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _studentClassController,
              decoration: const InputDecoration(labelText: 'Student Class'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dateofBirthController,
              decoration: const InputDecoration(labelText: 'Date of Birth'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _adressController,
              decoration: const InputDecoration(labelText: 'Adress'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    
                    
                    if (widget.isEdit) {
                      print('Edit User');
                    } else {
                      context.read<UserProfileBloc>().add(
                          CreateUserProfileEvent(
                            profile: Profile(
                              fullName: _nameController.text,
                              email: _emailController.text,
                              studentCode: _studentCodeController.text,
                              studentClass: _studentClassController.text,
                              dob: _dateofBirthController.text,
                              address: _adressController.text,
                              password: _passwordController.text,
                            ),
                          ),
                          
                        );
                        Navigator.of(context).pop();
                        context.read<UserProfileBloc>().add((FetchUserProfilesEvent(keyWord: '', choice: 'userId')));
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _nameController.text =
        context.read<UserProfileCubit>().state.fullName ?? '';
    _emailController.text = context.read<UserProfileCubit>().state.email ?? '';
    _studentCodeController.text =
        context.read<UserProfileCubit>().state.studentCode ?? '';
    _studentClassController.text =
        context.read<UserProfileCubit>().state.studentClass ?? '';
    _dateofBirthController.text =
        context.read<UserProfileCubit>().state.dob ?? '';
    _adressController.text =
        context.read<UserProfileCubit>().state.address ?? '';

    _nameController.addListener(() {
      context.read<UserProfileCubit>().setFullName(_nameController.text);
    });
    _emailController.addListener(() {
      context.read<UserProfileCubit>().setEmail(_emailController.text);
    });
    _studentCodeController.addListener(() {
      context
          .read<UserProfileCubit>()
          .setStudentCode(_studentCodeController.text);
    });
    _studentClassController.addListener(() {
      context
          .read<UserProfileCubit>()
          .setStudentClass(_studentClassController.text);
    });
    _dateofBirthController.addListener(() {
      context.read<UserProfileCubit>().setDob(_dateofBirthController.text);
    });
    _adressController.addListener(() {
      context.read<UserProfileCubit>().setAddress(_adressController.text);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _studentCodeController.dispose();
    _studentClassController.dispose();
    _dateofBirthController.dispose();
    _adressController.dispose();
    super.dispose();
  }
}
