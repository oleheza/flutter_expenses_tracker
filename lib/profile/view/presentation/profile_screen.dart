import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/repository/auth_repository.dart';
import '../../../core/domain/repository/profile_repository.dart';
import '../bloc/profile_cubit.dart';
import 'profile_screen_content.dart';

class ProfileScreen extends StatelessWidget {
  final AuthRepository authRepository;
  final ProfileRepository profileRepository;

  const ProfileScreen({
    super.key,
    required this.authRepository,
    required this.profileRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(
        authRepository: authRepository,
        profileRepository: profileRepository,
      )..initialize(),
      child: const ProfileScreenContent(),
    );
  }
}
