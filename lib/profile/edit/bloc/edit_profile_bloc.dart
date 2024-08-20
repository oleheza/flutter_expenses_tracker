import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/domain/model/profile_model.dart';
import '../../../core/domain/repository/auth_repository.dart';
import '../domain/edit_profile_use_case.dart';
import '../domain/get_profile_by_user_id_use_case.dart';

part 'edit_profile_bloc.freezed.dart';
part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final GetProfileByUserIdUseCase getProfileByUserIdUseCase;
  final EditProfileUseCase editProfileUseCase;
  final AuthRepository authRepository;

  EditProfileBloc({
    required this.authRepository,
    required this.getProfileByUserIdUseCase,
    required this.editProfileUseCase,
  }) : super(const EditProfileState()) {
    on<EditProfileEvent>(
      (event, emit) async {
        await event.when(
          initialized: () async => _onInitialized(emit),
          userNameUpdated: (userName) async =>
              _onUserNameUpdated(emit, userName),
          updateProfile: () async => _onUpdateProfile(emit),
        );
      },
    );
  }

  Future<void> _onInitialized(Emitter<EditProfileState> emit) async {
    final currentUserId = authRepository.getCurrentUser()?.uid ?? '';
    final result = await getProfileByUserIdUseCase.execute(currentUserId);
    final profile = result.getRight().toNullable();
    if (profile != null) {
      emit(
        state.copyWith(
          profile: profile,
          userName: profile.userName,
        ),
      );
    }
  }

  void _onUserNameUpdated(
    Emitter<EditProfileState> emit,
    String? newUserName,
  ) {
    emit(
      state.copyWith(
        userName: newUserName,
        isValid: _isValid(newUserName),
      ),
    );
  }

  void _onUpdateProfile(Emitter<EditProfileState> emit) async {
    final newProfile = state.profile?.copyWith(userName: state.userName);
    if (newProfile == null) {
      return;
    }

    emit(state.copyWith(isLoading: true));

    final result = await editProfileUseCase.execute(newProfile);
    result.fold(
      (l) => null,
      (r) => emit(state.copyWith(isLoading: false, updated: true)),
    );
  }

  bool _isValid(String? newUserName) {
    return newUserName != null &&
        newUserName.isNotEmpty &&
        newUserName != state.profile?.userName;
  }
}
