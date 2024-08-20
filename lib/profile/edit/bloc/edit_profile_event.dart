part of 'edit_profile_bloc.dart';

@freezed
class EditProfileEvent with _$EditProfileEvent {
  const factory EditProfileEvent.initialized() = _Initialized;

  const factory EditProfileEvent.userNameUpdated({
    String? userName,
  }) = _UserNameUpdated;

  const factory EditProfileEvent.updateProfile() = _UpdateProfile;
}
