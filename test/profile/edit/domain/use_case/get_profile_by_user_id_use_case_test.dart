import 'package:expenses_tracker/core/domain/failure/failure.dart';
import 'package:expenses_tracker/core/domain/repository/profile_repository.dart';
import 'package:expenses_tracker/profile/edit/domain/get_profile_by_user_id_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fake_data/fake_data.dart';
import '../../../../mocks/repository_mocks.mocks.dart';

void main() {
  late GetProfileByUserIdUseCase getProfileByUserIdUseCase;
  late ProfileRepository profileRepository;

  final userId = fakeUser.uid!;

  setUp(() {
    profileRepository = MockProfileRepository();
    getProfileByUserIdUseCase = GetProfileByUserIdUseCase(profileRepository);
  });

  test('test get profile by user id returns correct profile', () async {
    when(profileRepository.getProfile(userId))
        .thenAnswer((_) async => fakeProfile);

    final result = await getProfileByUserIdUseCase.execute(userId);

    verify(profileRepository.getProfile(userId)).called(1);
    expect(result.getRight().toNullable(), fakeProfile);
  });

  test('test failed get profile by user id returns correct failure', () async {
    when(profileRepository.getProfile(userId)).thenThrow(Exception());

    final result = await getProfileByUserIdUseCase.execute(userId);

    verify(profileRepository.getProfile(userId)).called(1);
    expect(result.getLeft().toNullable(), const Failure.genericFailure());
  });
}
