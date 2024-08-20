import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/domain/repository/auth_repository.dart';
import '../../core/domain/repository/settings_repository.dart';
import '../bloc/settings_bloc.dart';
import '../domain/use_case/delete_account_use_case.dart';
import '../domain/use_case/logout_use_case.dart';
import 'settings_screen_content.dart';

class SettingsScreen extends StatelessWidget {
  final LogoutUseCase logoutUseCase;
  final SettingsRepository settingsRepository;
  final DeleteAccountUseCase deleteAccountUseCase;
  final AuthRepository authRepository;

  const SettingsScreen({
    super.key,
    required this.logoutUseCase,
    required this.settingsRepository,
    required this.deleteAccountUseCase,
    required this.authRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsBloc(
        logoutUseCase: logoutUseCase,
        settingsRepository: settingsRepository,
        deleteAccountUseCase: deleteAccountUseCase,
        authRepository: authRepository,
      )..add(const SettingsEvent.initialized()),
      child: const SettingsScreenContent(),
    );
  }
}
