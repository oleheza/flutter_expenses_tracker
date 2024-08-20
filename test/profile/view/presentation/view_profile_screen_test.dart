import 'package:expenses_tracker/core/domain/repository/auth_repository.dart';
import 'package:expenses_tracker/core/domain/repository/profile_repository.dart';
import 'package:expenses_tracker/core/presentation/build_context_extensions.dart';
import 'package:expenses_tracker/profile/view/presentation/profile_screen.dart';
import 'package:expenses_tracker/profile/view/presentation/profile_screen_content.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';

import '../../../core/presentation/testable_widget.dart';
import '../../../fake_data/fake_data.dart';
import '../../../mocks/repository_mocks.mocks.dart';
import '../../../mocks/third_party_mocks.mocks.dart';

void main() {
  late GoRouter goRouter;
  late AuthRepository authRepository;
  late ProfileRepository profileRepository;

  setUp(() {
    goRouter = MockGoRouter();
    authRepository = MockAuthRepository();
    profileRepository = MockProfileRepository();

    when(authRepository.getCurrentUser()).thenReturn(fakeUser);
  });

  Widget createTestableWidget() {
    return TestableWidget(
      mockGoRouter: goRouter,
      child: ProfileScreen(
        authRepository: authRepository,
        profileRepository: profileRepository,
      ),
    );
  }

  testWidgets(
    'test profile screen displays correct data',
    (tester) async {
      when(profileRepository.subscribeToProfileChanges(fakeUser.uid!))
          .thenAnswer((_) => Stream.value(fakeProfile));

      await tester.pumpWidget(createTestableWidget());
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(ProfileScreenContent));

      expect(find.text(context.tr.userName), findsOneWidget);
      expect(find.text(fakeProfile.userName ?? ''), findsOneWidget);

      expect(find.text(context.tr.email), findsOneWidget);
      expect(find.text(fakeProfile.email), findsOneWidget);
    },
  );
}
