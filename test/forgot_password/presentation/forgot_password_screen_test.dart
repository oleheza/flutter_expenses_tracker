import 'package:expenses_tracker/core/domain/failure/failure.dart';
import 'package:expenses_tracker/core/domain/failure/reset_password_failure_reason.dart';
import 'package:expenses_tracker/core/domain/validator/validator.dart';
import 'package:expenses_tracker/core/presentation/build_context_extensions.dart';
import 'package:expenses_tracker/core/presentation/widget_keys.dart';
import 'package:expenses_tracker/core/presentation/widgets/adaptive/adaptive_scaffold.dart';
import 'package:expenses_tracker/forgot_password/domain/use_case/request_forgot_password_use_case.dart';
import 'package:expenses_tracker/forgot_password/presentation/forgot_password_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';

import '../../core/presentation/testable_widget.dart';
import '../../fake_data/fake_data.dart';
import '../../mocks/third_party_mocks.mocks.dart';
import '../../mocks/use_case_mocks.mocks.dart';
import 'forgot_password_screen_robot.dart';

void main() {
  late GoRouter goRouter;
  late Validator validator;
  late RequestForgotPasswordUseCase forgotPasswordUseCase;

  setUp(() {
    goRouter = MockGoRouter();
    validator = Validator();
    forgotPasswordUseCase = MockRequestForgotPasswordUseCase();

    provideDummy<Either<Failure, void>>(const Right(null));
  });

  Widget createTestableWidget() {
    return TestableWidget(
      mockGoRouter: goRouter,
      child: ForgotPasswordScreen(
        forgotPasswordUseCase: forgotPasswordUseCase,
        validator: validator,
      ),
    );
  }

  testWidgets(
    'test forgot password screen has all required widgets',
    (tester) async {
      await tester.pumpWidget(createTestableWidget());

      final context = tester.element(find.byType(AdaptiveScaffold));

      expect(find.byKey(WidgetKeys.forgotPasswordEmailKey), findsOneWidget);
      expect(find.byKey(WidgetKeys.forgotPasswordResetKey), findsOneWidget);
      expect(find.text(context.tr.recoverPasswordTitle), findsOneWidget);
    },
  );

  testWidgets(
    'test forgot password request with incorrect email cannot be submitted',
    (tester) async {
      const enteredEmail = 'alex';

      await tester.pumpWidget(createTestableWidget());

      final robot = ForgotPasswordScreenRobot(tester: tester);

      await robot.enterEmail(enteredEmail);
      await robot.clickResetPassword();

      verifyNever(forgotPasswordUseCase.execute(enteredEmail));
    },
  );

  testWidgets(
    'test forgot password success request is correct',
    (tester) async {
      await tester.pumpWidget(createTestableWidget());

      final context = tester.element(find.byType(AdaptiveScaffold));
      final robot = ForgotPasswordScreenRobot(tester: tester);

      await robot.enterEmail(fakeEmail);
      await robot.clickResetPassword();

      expect(find.text(context.tr.loading), findsOneWidget);
      await tester.pump();

      expect(find.text(context.tr.resetPasswordSuccess), findsOneWidget);

      await robot.clickOkInDialog();

      verify(goRouter.pop()).called(greaterThanOrEqualTo(2));
    },
  );

  Future<void> testFailedForgotPasswordRequest(
    WidgetTester tester,
    ResetPasswordFailureReason expectedReason,
    String expectedMessage,
  ) async {
    provideDummy<Either<Failure, void>>(
        Left(Failure.resetPasswordFailure(reason: expectedReason)));

    when(forgotPasswordUseCase.execute(fakeEmail)).thenAnswer((_) async =>
        Left(Failure.resetPasswordFailure(reason: expectedReason)));

    final robot = ForgotPasswordScreenRobot(tester: tester);

    await robot.enterEmail(fakeEmail);
    await robot.clickResetPassword();

    await tester.pump();
    await tester.pump();

    expect(find.text(expectedMessage), findsOneWidget);

    await robot.clickOkInDialog();

    verify(goRouter.pop()).called(1);
  }

  testWidgets(
    'test failed forgot password request when email is invalid is handled correctly',
    (tester) async {
      await tester.pumpWidget(createTestableWidget());

      final context = tester.element(find.byType(AdaptiveScaffold));

      await testFailedForgotPasswordRequest(
        tester,
        const ResetPasswordFailureReason.invalidEmail(),
        context.tr.resetPasswordFailureInvalidEmail,
      );
    },
  );

  testWidgets(
    'test failed forgot password request when user is not found is handled correctly',
    (tester) async {
      await tester.pumpWidget(createTestableWidget());

      final context = tester.element(find.byType(AdaptiveScaffold));

      await testFailedForgotPasswordRequest(
        tester,
        const ResetPasswordFailureReason.userNotFound(),
        context.tr.resetPasswordFailureUserNotFound,
      );
    },
  );

  testWidgets(
    'test failed forgot password request when failure is unknown is handled correctly',
    (tester) async {
      await tester.pumpWidget(createTestableWidget());

      final context = tester.element(find.byType(AdaptiveScaffold));

      await testFailedForgotPasswordRequest(
        tester,
        const ResetPasswordFailureReason.unknown(),
        context.tr.resetPasswordFailureUnknown,
      );
    },
  );
}
