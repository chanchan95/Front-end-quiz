import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:ptit_quiz_frontend/domain/entities/profile.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/cubits/user_profile_cubit.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/user_profile_bloc/user_profile_bloc.dart';
import 'package:ptit_quiz_frontend/presentation/screens/widgets/app_dialog.dart';
import 'package:ptit_quiz_frontend/presentation/screens/widgets/widgets.dart';
import 'package:toastification/toastification.dart';

class AdminUserScreen extends StatefulWidget {
  const AdminUserScreen({super.key});

  @override
  State<AdminUserScreen> createState() => _AdminUserScreenState();
}

class _AdminUserScreenState extends State<AdminUserScreen> {
  final bool isAdmin = true;
  late List<Profile> profiles;
  var keyWord = '';
  var choice = 'userId';
  var limit = 5;
  var current_page = 0;

  List<String> choices = ['userId', 'fullName'];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserProfileBloc, UserProfileState>(
      listener: (context, state) {
        if (state is UserProfileStateError) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            toastification.show(
              context: context,
              type: ToastificationType.error,
              style: ToastificationStyle.flatColored,
              title: const Text('Error'),
              description: Text(state.message),
              alignment: Alignment.topRight,
              autoCloseDuration: const Duration(seconds: 3),
              showProgressBar: false,
            );
          });
        }
        if (state is UserProfileListLoaded) {
          profiles = state.profiles;
        }
      },
      builder: (context, state) {
        if (state is UserProfileStateLoading) {
          return const Center(
            child: AppLoadingAnimation(),
          );
        } else if (state is UserProfileListLoaded) {
          profiles = state.profiles;
          var profiles_length = state.profiles.length;
          var number_of_pages = (profiles_length / limit).ceil();
          List<Profile> current_profiles = profiles.sublist(
              current_page * limit,
              min(current_page * limit + limit, profiles_length));
          // print(current_profiles);
          // if (profiles_length == 0) {
          //   return const Center(child: Text('No users found'));
          // }
          return SingleChildScrollView(
              child: Row(
            children: [
              Expanded(
                  child: Center(
                      child: Container(
                          constraints: BoxConstraints(
                            maxWidth: 10000,
                            minHeight: MediaQuery.of(context).size.height,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              children: [
                                Container(
                                    alignment: Alignment.centerRight,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        if (isAdmin) ...[
                                          IconButton(
                                            onPressed: () {
                                              context
                                                  .read<UserProfileCubit>()
                                                  .setProfile(Profile.empty());
                                              AppDialog.showUserProfileDialog(
                                                  context,
                                                  isEdit: false);
                                            },
                                            icon: const Icon(Icons.add),
                                          ),
                                          const SizedBox(width: 16),
                                        ],
                                        Container(
                                          width: 200,
                                          height: 40,
                                          child: TextField(
                                            onChanged: (value) {
                                              keyWord = value;
                                            },
                                            decoration: InputDecoration(
                                              hintText: 'Search',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          width: 100,
                                          child: DropdownButton<String>(
                                            value: choice,
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                choice = newValue!;
                                              });
                                            },
                                            items: choices
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        FilledButton(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5))),
                                          ),
                                          onPressed: () {
                                            context.read<UserProfileBloc>().add(
                                                FetchUserProfilesEvent(
                                                    keyWord: keyWord,
                                                    choice: choice));
                                          },
                                          child: const Text('Search'),
                                        ),
                                      ],
                                    )),
                                const SizedBox(height: 10),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: current_profiles.length,
                                  itemBuilder: (context, index) {
                                    return UserCard(
                                      profile: current_profiles[index],
                                      onPressed: () {
                                        context
                                            .read<UserProfileCubit>()
                                            .setProfile(
                                                current_profiles[index]);
                                        AppDialog.showUserProfileDialog(
                                          context,
                                          isEdit: true,
                                        );
                                      },
                                    );
                                  },
                                ),
                                Text(
                                  'Page ${current_page + 1} of $number_of_pages',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    width: 400,
                                    child: NumberPaginator(
                                      numberPages: number_of_pages,
                                      onPageChange: (int index) {
                                        setState(() {
                                          current_page = index;
                                        });
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ))))
            ],
          ));
        } else {
          return const Center(child: Text('No users found'));
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    context
        .read<UserProfileBloc>()
        .add(FetchUserProfilesEvent(keyWord: keyWord, choice: choice));
  }
}

class UserCard extends StatelessWidget {
  final Profile profile;
  final Function()? onPressed;

  const UserCard({required this.profile, this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    bool isMedium = MediaQuery.of(context).size.width > 800;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Flex(
            direction: isMedium ? Axis.horizontal : Axis.vertical,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  'assets/images/persion.png',
                  width: 120,
                  height: 120,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.fullName!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    profile.studentClass!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    profile.studentCode!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  // const SizedBox(height: 10),
                ],
              ),
              isMedium ? const Spacer() : const SizedBox(width: 20),
              Padding(
                  padding: const EdgeInsets.all(32),
                  child: FilledButton(
                    onPressed: onPressed,
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Center(
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
