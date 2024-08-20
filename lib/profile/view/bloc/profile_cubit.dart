import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/domain/model/profile_model.dart';
import '../../../core/domain/repository/auth_repository.dart';
import '../../../core/domain/repository/profile_repository.dart';

part 'profile_cubit.freezed.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;
  final AuthRepository authRepository;

  StreamSubscription<ProfileModel?>? _subscription;

  ProfileCubit({
    required this.authRepository,
    required this.profileRepository,
  }) : super(const ProfileState());

  void initialize() {
    _subscribeToUserChanges();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  void _subscribeToUserChanges() {
    final currentUserId = authRepository.getCurrentUser()?.uid ?? '';
    _subscription = profileRepository
        .subscribeToProfileChanges(currentUserId)
        .listen((event) => emit(state.copyWith(
              email: event?.email,
              userName: event?.userName,
            )));
  }
}
