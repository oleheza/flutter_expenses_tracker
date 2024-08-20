part of 'edit_profile_bloc.dart';

@freezed
class EditProfileState with _$EditProfileState {
  const factory EditProfileState({
    ProfileModel? profile,
    String? userName,
    @Default(false) bool isLoading,
    @Default(false) bool updated,
    @Default(false) bool isValid,
  }) = _EditProfileState;
}
