import 'package:expenses_tracker/auth/domain/use_case/create_profile_use_case.dart';
import 'package:expenses_tracker/core/domain/failure/failure.dart';
import 'package:expenses_tracker/core/domain/repository/profile_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fake_data/fake_data.dart';
import '../../../mocks/repository_mocks.mocks.dart';

void main() {
  late CreateProfileUseCase createProfileUseCase;
  late ProfileRepository profileRepository;

  setUp(() {
    profileRepository = MockProfileRepository();
    createProfileUseCase = CreateProfileUseCase(
      profileRepository: profileRepository,
    );
  });

  test('test create user profile returns nothing on success', () async {
    when(profileRepository.createProfile(fakeProfile))
        .thenAnswer((_) async => {});

    final result = await createProfileUseCase.execute(fakeProfile);

    verify(profileRepository.createProfile(fakeProfile)).called(1);
    expect(result.isRight(), true);
  });

  test('test create user profile returns failure ', () async {
    when(profileRepository.createProfile(fakeProfile)).thenThrow(Exception());

    final result = await createProfileUseCase.execute(fakeProfile);

    verify(profileRepository.createProfile(fakeProfile)).called(1);
    expect(result.isLeft(), true);
    expect(result.getLeft().toNullable(), const Failure.genericFailure());
  });
}
