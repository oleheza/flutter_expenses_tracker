import 'package:bloc_test/bloc_test.dart';
import 'package:expenses_tracker/core/domain/repository/auth_repository.dart';
import 'package:expenses_tracker/core/domain/repository/profile_repository.dart';
import 'package:expenses_tracker/profile/view/bloc/profile_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fake_data/fake_data.dart';
import '../../../mocks/repository_mocks.mocks.dart';

void main() {
  late ProfileCubit profileCubit;
  late AuthRepository authRepository;
  late ProfileRepository profileRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    profileRepository = MockProfileRepository();
    profileCubit = ProfileCubit(
      authRepository: authRepository,
      profileRepository: profileRepository,
    );
  });

  blocTest(
    'test view profile has correct data',
    build: () => profileCubit,
    setUp: () {
      when(authRepository.getCurrentUser()).thenReturn(fakeUser);
      when(profileRepository.subscribeToProfileChanges(fakeUser.uid!))
          .thenAnswer((_) => Stream.value(fakeProfile));
    },
    act: (cubit) => cubit.initialize(),
    expect: () {
      return <ProfileState>[
        ProfileState(userName: fakeProfile.userName, email: fakeProfile.email)
      ];
    },
    tearDown: () => profileCubit.close(),
  );
}
