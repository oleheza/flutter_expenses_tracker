part of 'profile_cubit.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    String? email,
    String? userName,
  }) = _ProfileState;
}
