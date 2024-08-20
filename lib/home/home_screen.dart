import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/domain/repository/auth_repository.dart';
import '../core/domain/repository/expenses_repository.dart';
import '../core/domain/repository/profile_repository.dart';
import '../core/domain/repository/settings_repository.dart';
import '../core/presentation/build_context_extensions.dart';
import '../core/presentation/widgets/adaptive/adaptive_app_bar.dart';
import '../core/presentation/widgets/adaptive/adaptive_tab_scaffold.dart';
import '../create_or_update_expenses/presentation/create_or_update_expenses_screen.dart';
import '../expenses/tabs/presentation/expenses_tabs_screen.dart';
import '../profile/edit/presentation/edit_profile_screen.dart';
import '../profile/view/presentation/profile_screen.dart';
import '../settings/domain/use_case/delete_account_use_case.dart';
import '../settings/domain/use_case/logout_use_case.dart';
import '../settings/presentation/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  static const route = '/';
  static const screenName = 'home';

  final AuthRepository authRepository;
  final SettingsRepository settingsRepository;
  final ProfileRepository profileRepository;
  final ExpensesRepository expensesRepository;

  final LogoutUseCase logoutUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;

  const HomeScreen({
    super.key,
    required this.authRepository,
    required this.settingsRepository,
    required this.profileRepository,
    required this.expensesRepository,
    required this.logoutUseCase,
    required this.deleteAccountUseCase,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _expensesTabIndex = 0;
  static const _profileTabIndex = 1;
  static const _settingsTabIndex = 2;

  late List<Widget> pages;

  int selectedTab = _expensesTabIndex;

  Widget? _buildCupertinoTrailingIcon(
    int selectedTabIndex,
    VoidCallback onAddPressed,
    VoidCallback onEditProfilePressed,
  ) {
    return switch (selectedTabIndex) {
      _expensesTabIndex => IconButton(
          iconSize: 24,
          onPressed: onAddPressed,
          icon: const Icon(CupertinoIcons.add),
        ),
      _profileTabIndex => IconButton(
          iconSize: 24,
          onPressed: onEditProfilePressed,
          icon: const Icon(CupertinoIcons.pencil),
        ),
      _settingsTabIndex => null,
      _ => null,
    };
  }

  @override
  void initState() {
    super.initState();
    pages = <Widget>[
      ExpensesTabsScreen(
        authRepository: widget.authRepository,
        settingsRepository: widget.settingsRepository,
        expensesRepository: widget.expensesRepository,
      ),
      ProfileScreen(
        authRepository: widget.authRepository,
        profileRepository: widget.profileRepository,
      ),
      SettingsScreen(
        authRepository: widget.authRepository,
        settingsRepository: widget.settingsRepository,
        logoutUseCase: widget.logoutUseCase,
        deleteAccountUseCase: widget.deleteAccountUseCase,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    onAddPressed() =>
        context.pushNamed(CreateOrUpdateExpensesScreen.screenName);

    onEditProfile() => context.pushNamed(EditProfileScreen.screenName);

    return AdaptiveTabScaffold(
      appBar: AdaptiveAppBar(
        material: (_) => MaterialAppBarData(
          title: Text(context.tr.expensesTracker),
          actions: selectedTab == _profileTabIndex
              ? <Widget>[
                  IconButton(
                    onPressed: onEditProfile,
                    icon: const Icon(Icons.edit),
                  )
                ]
              : null,
        ),
        cupertino: (_) => CupertinoAppBarData(
          middle: Text(context.tr.expensesTracker),
          trailing: _buildCupertinoTrailingIcon(
            selectedTab,
            onAddPressed,
            onEditProfile,
          ),
        ),
      ),
      material: (_) => MaterialTabScaffoldData(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: context.tr.allExpenses,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: context.tr.profile,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: context.tr.settings,
          ),
        ],
        floatingActionButton: selectedTab == _expensesTabIndex
            ? FloatingActionButton(
                onPressed: onAddPressed,
                child: const Icon(Icons.add),
              )
            : null,
      ),
      cupertino: (_) => CupertinoTabScaffoldData(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.list_bullet),
            label: context.tr.allExpenses,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.person),
            label: context.tr.profile,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.settings),
            label: context.tr.settings,
          ),
        ],
      ),
      pages: pages,
      onTabSelected: (index) {
        setState(() {
          selectedTab = index ?? selectedTab;
        });
      },
    );
  }
}
