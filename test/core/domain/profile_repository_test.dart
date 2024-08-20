import 'package:expenses_tracker/core/data/repository/firebase_profile_repository.dart';
import 'package:expenses_tracker/core/domain/exceptions/profile_not_found_exception.dart';
import 'package:expenses_tracker/core/domain/model/profile_model.dart';
import 'package:expenses_tracker/core/domain/repository/profile_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fake_data/fake_data.dart';

void main() {
  late ProfileRepository profileRepository;

  setUp(
    () {
      profileRepository =
          FirebaseProfileRepository(firebaseFirestore: FakeFirebaseFirestore());
    },
  );

  test(
    'test firestore returns created profile',
    () async {
      await profileRepository.createProfile(fakeProfile);

      final profile = await profileRepository.getProfile(fakeProfile.userId);
      expect(fakeProfile.email == profile.email, isTrue);
      expect(fakeProfile.userId == profile.userId, isTrue);
      expect(fakeProfile.userName == profile.userName, isTrue);
    },
  );

  test(
    'test get not existing profile throws exception',
    () async {
      await profileRepository.createProfile(fakeProfile);

      await profileRepository.deleteProfile(fakeProfile.userId);

      expect(
        () => profileRepository.getProfile(fakeProfile.userId),
        throwsA(isA<ProfileNotFoundException>()),
      );
    },
  );

  test(
    'test firestore returns correct profile after update',
    () async {
      await profileRepository.createProfile(fakeProfile);

      final profile = await profileRepository.getProfile(fakeProfile.userId);

      final newProfile = profile.copyWith(userName: 'new_super_user');

      await profileRepository.updateProfile(newProfile);

      final updatedProfile =
          await profileRepository.getProfile(fakeProfile.userId);

      expect(updatedProfile == newProfile, isTrue);
    },
  );

  test(
    'test profile stream returns correct items',
    () {
      profileRepository.createProfile(fakeProfile);
      profileRepository.deleteProfile(fakeProfile.userId);

      final stream =
          profileRepository.subscribeToProfileChanges(fakeProfile.userId);

      expect(stream, emitsInOrder([isA<ProfileModel>(), null]));
    },
  );
}
