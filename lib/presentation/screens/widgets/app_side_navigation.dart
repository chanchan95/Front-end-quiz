import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ptit_quiz_frontend/presentation/screens/widgets/ptit_logo.dart';

import '../../../core/router/app_router.dart';
import '../../blocs/app_bloc.dart';

class AppSideNavigation extends StatefulWidget {
  final Widget child;

  const AppSideNavigation({super.key, required this.child});

  @override
  State<AppSideNavigation> createState() => _AppSideNavigationState();
}

class _AppSideNavigationState extends State<AppSideNavigation> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    bool isExtended = MediaQuery.of(context).size.width > 1000;
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is! AuthStateAuthenticated &&
                state is! AuthStateAdminAuthenticated) {
              context.go(AppRoutes.login);
            }
          },
          builder: (context, state) {
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: NavigationRail(
                    extended: isExtended,
                    selectedIndex: _selectedIndex,
                    groupAlignment: -1.0,
                    onDestinationSelected: (int index) {
                      setState(() {
                        _selectedIndex = index;
                        if (state is AuthStateAuthenticated) {
                          switch (index) {
                            case 0:
                              context.go(AppRoutes.home);
                              break;
                            case 1:
                              context.go(AppRoutes.exam);
                              break;
                            case 2:
                              context.go(AppRoutes.result);
                              break;
                          }
                        } else if (state is AuthStateAdminAuthenticated) {
                          switch (index) {
                            case 0:
                              context.go(AppRoutes.adminCourse);
                              break;
                            case 1:
                              context.go(AppRoutes.adminExam);
                              break;
                            case 2:
                              context.go(AppRoutes.adminUser);
                              break;
                            case 3:
                              context.go(AppRoutes.adminStatistics);
                              break;
                          }
                        }
                      });
                    },
                    indicatorColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    selectedIconTheme: IconThemeData(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    selectedLabelTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelTextStyle: const TextStyle(fontSize: 16),
                    labelType: isExtended
                        ? NavigationRailLabelType.none
                        : NavigationRailLabelType.selected,
                    leading: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          if (state is AuthStateAuthenticated) {
                            context.go(AppRoutes.home);
                          } else if (state is AuthStateAdminAuthenticated) {
                            context.go(AppRoutes.adminCourse);
                          }
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(isExtended ? 16.0 : 8.0),
                              child: PtitLogo(size: isExtended ? 120 : 40),
                            ),
                            SizedBox(height: isExtended ? 20 : 8),
                          ],
                        ),
                      ),
                    ),
                    destinations: [
                      if (state is AuthStateAuthenticated)
                        const NavigationRailDestination(
                          icon: Icon(Icons.school_outlined),
                          selectedIcon: Icon(Icons.school),
                          label: Text('Course'),
                        ),
                      if (state is AuthStateAuthenticated)
                        const NavigationRailDestination(
                          icon: Icon(Icons.article_outlined),
                          selectedIcon: Icon(Icons.article),
                          label: Text('Exam'),
                        ),
                      if (state is AuthStateAuthenticated)
                        const NavigationRailDestination(
                          icon: Icon(Icons.assessment_outlined),
                          selectedIcon: Icon(Icons.assessment),
                          label: Text('Result'),
                        ),
                      if (state is AuthStateAdminAuthenticated)
                        const NavigationRailDestination(
                          icon: Icon(Icons.school_outlined),
                          selectedIcon: Icon(Icons.school),
                          label: Text('Course'),
                        ),
                      if (state is AuthStateAdminAuthenticated)
                        const NavigationRailDestination(
                          icon: Icon(Icons.article_outlined),
                          selectedIcon: Icon(Icons.article),
                          label: Text('Exam'),
                        ),
                      if (state is AuthStateAdminAuthenticated)
                        const NavigationRailDestination(
                          icon: Icon(Icons.person_outlined),
                          selectedIcon: Icon(Icons.person),
                          label: Text('Student'),
                        ),
                      if (state is AuthStateAdminAuthenticated)
                        const NavigationRailDestination(
                          icon: Icon(Icons.bar_chart_outlined),
                          selectedIcon: Icon(Icons.bar_chart),
                          label: Text('Statistics'),
                        ),
                      if (state is AuthStateUnauthenticated)
                        const NavigationRailDestination(
                          icon: Icon(Icons.login_outlined),
                          selectedIcon: Icon(Icons.login),
                          label: Text('Login'),
                        ),
                      if (state is AuthStateUnauthenticated)
                        const NavigationRailDestination(
                          icon: Icon(Icons.login_outlined),
                          selectedIcon: Icon(Icons.login),
                          label: Text('Admin Login'),
                        ),
                    ],
                  ),
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                    child: Scaffold(
                  appBar: AppBar(
                    title: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        state is AuthStateAdminAuthenticated
                            ? 'PTIT Quiz Admin'
                            : 'PTIT Quiz',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () {
                          context.read<AuthBloc>().add(const AuthLogoutEvent());
                        },
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                  body: widget.child,
                )),
              ],
            );
          },
        ),
      ),
    );
  }
}
