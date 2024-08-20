import '../model/profile_model.dart';

abstract interface class ProfileRepository {
  Future<void> createProfile(ProfileModel profile);

  Future<void> updateProfile(ProfileModel profile);

  Future<void> deleteProfile(String userId);

  Stream<ProfileModel?> subscribeToProfileChanges(String userId);

  Future<ProfileModel> getProfile(String userId);
}
