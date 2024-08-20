import 'package:bloc_test/bloc_test.dart';
import 'package:expenses_tracker/core/domain/failure/failure.dart';
import 'package:expenses_tracker/core/domain/model/profile_model.dart';
import 'package:expenses_tracker/core/domain/repository/auth_repository.dart';
import 'package:expenses_tracker/profile/edit/bloc/edit_profile_bloc.dart';
import 'package:expenses_tracker/profile/edit/domain/edit_profile_use_case.dart';
import 'package:expenses_tracker/profile/edit/domain/get_profile_by_user_id_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';

import '../../../fake_data/fake_data.dart';
import '../../../mocks/repository_mocks.mocks.dart';
import '../../../mocks/use_case_mocks.mocks.dart';

void main() {
  late EditProfileBloc editProfileBloc;
  late AuthRepository authRepository;
  late GetProfileByUserIdUseCase getProfileByUserIdUseCase;
  late EditProfileUseCase editProfileUseCase;

  final fakeUserId = fakeUser.uid!;
  const String newUserName = 'test_user';

  setUp(() {
    provideDummy<Either<Failure, ProfileModel>>(Right(fakeProfile));
    provideDummy<Either<Failure, void>>(const Right(null));

    authRepository = MockAuthRepository();
    getProfileByUserIdUseCase = MockGetProfileByUserIdUseCase();
    editProfileUseCase = MockEditProfileUseCase();
    editProfileBloc = EditProfileBloc(
      authRepository: authRepository,
      getProfileByUserIdUseCase: getProfileByUserIdUseCase,
      editProfileUseCase: editProfileUseCase,
    );
  });

  blocTest(
    'test edit profile bloc emits correct state',
    build: () => editProfileBloc,
    setUp: () {
      when(getProfileByUserIdUseCase.execute(fakeUserId))
          .thenAnswer((_) async => Right(fakeProfile));
    },
    act: (bloc) {
      bloc.add(const EditProfileEvent.initialized());
      bloc.add(const EditProfileEvent.userNameUpdated(userName: newUserName));
      bloc.add(const EditProfileEvent.updateProfile());
    },
    verify: (_) {
      return <EditProfileState>[
        EditProfileState(profile: fakeProfile, userName: fakeProfile.userName),
        EditProfileState(
          profile: fakeProfile,
          userName: newUserName,
          isValid: true,
        ),
        EditProfileState(
          profile: fakeProfile,
          userName: newUserName,
          isValid: true,
          isLoading: true,
        ),
        EditProfileState(
          profile: fakeProfile,
          userName: newUserName,
          isValid: true,
          updated: true,
        ),
      ];
    },
    tearDown: () => editProfileBloc.close(),
  );
}
