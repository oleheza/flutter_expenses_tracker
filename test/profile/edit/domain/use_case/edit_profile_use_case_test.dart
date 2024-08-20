import 'package:expenses_tracker/core/domain/failure/failure.dart';
import 'package:expenses_tracker/core/domain/repository/profile_repository.dart';
import 'package:expenses_tracker/profile/edit/domain/edit_profile_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';

import '../../../../fake_data/fake_data.dart';
import '../../../../mocks/repository_mocks.mocks.dart';

void main() {
  late EditProfileUseCase editProfileUseCase;
  late ProfileRepository profileRepository;

  setUp(() {
    profileRepository = MockProfileRepository();
    editProfileUseCase = EditProfileUseCase(profileRepository);
  });

  test('test successful edit profile returns correct result', () async {
    when(profileRepository.updateProfile(fakeProfile))
        .thenAnswer((_) async => {});

    final result = await editProfileUseCase.execute(fakeProfile);
    verify(profileRepository.updateProfile(fakeProfile)).called(1);
    expect(result, isA<Right>());
  });

  test('test failed edit profile returns correct failure', () async {
    when(profileRepository.updateProfile(fakeProfile)).thenThrow(Exception());

    final result = await editProfileUseCase.execute(fakeProfile);
    verify(profileRepository.updateProfile(fakeProfile)).called(1);
    expect(result.getLeft().toNullable(), const Failure.genericFailure());
  });
}
