import 'package:expenses_tracker/core/domain/failure/failure.dart';
import 'package:expenses_tracker/core/domain/model/profile_model.dart';
import 'package:expenses_tracker/core/domain/repository/auth_repository.dart';
import 'package:expenses_tracker/profile/edit/domain/edit_profile_use_case.dart';
import 'package:expenses_tracker/profile/edit/domain/get_profile_by_user_id_use_case.dart';
import 'package:expenses_tracker/profile/edit/presentation/edit_profile_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';

import '../../../core/presentation/testable_widget.dart';
import '../../../fake_data/fake_data.dart';
import '../../../mocks/repository_mocks.mocks.dart';
import '../../../mocks/third_party_mocks.mocks.dart';
import '../../../mocks/use_case_mocks.mocks.dart';
import 'edit_profile_robot.dart';

void main() {
  late GoRouter goRouter;
  late AuthRepository authRepository;
  late GetProfileByUserIdUseCase getProfileByUserIdUseCase;
  late EditProfileUseCase editProfileUseCase;

  setUp(() {
    goRouter = MockGoRouter();
    authRepository = MockAuthRepository();
    getProfileByUserIdUseCase = MockGetProfileByUserIdUseCase();
    editProfileUseCase = MockEditProfileUseCase();
  });

  Widget createTestableWidget() {
    return TestableWidget(
      mockGoRouter: goRouter,
      child: EditProfileScreen(
        authRepository: authRepository,
        getProfileByUserIdUseCase: getProfileByUserIdUseCase,
        editProfileUseCase: editProfileUseCase,
      ),
    );
  }

  testWidgets(
    'test edit profile screen is correct',
    (tester) async {
      const newUserName = 'perfect.user';

      provideDummy<Either<Failure, ProfileModel>>(Right(fakeProfile));
      provideDummy<Either<Failure, void>>(const Right(null));

      await tester.pumpWidget(createTestableWidget());

      when(authRepository.getCurrentUser()).thenReturn(fakeUser);
      when(getProfileByUserIdUseCase.execute(fakeUser.uid!))
          .thenAnswer((_) async => Right(fakeProfile));

      final robot = EditProfileRobot(tester: tester);

      await robot.clickEditButton();
      verifyNever(editProfileUseCase.execute(fakeProfile));

      final newProfile = fakeProfile.copyWith(userName: newUserName);

      await robot.enterNewUserName(newUserName);
      await robot.clickEditButton();

      verify(editProfileUseCase.execute(newProfile)).called(1);
      verify(goRouter.canPop()).called(2);
    },
  );
}
