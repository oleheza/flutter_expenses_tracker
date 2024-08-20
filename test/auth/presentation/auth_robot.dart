import 'package:expenses_tracker/core/presentation/widget_keys.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../core/presentation/base_robot.dart';

class AuthRobot extends BaseRobot {
  AuthRobot({required super.tester});

  Future<void> enterEmail(String email) {
    return enterText(WidgetKeys.authEmailKey, email);
  }

  Future<void> enterPassword(String password) {
    return enterText(WidgetKeys.authPasswordKey, password);
  }

  Future<void> clickSignInButton() {
    return clickWidget(WidgetKeys.authSignInKey);
  }

  Future<void> clickSwitchSignInModeButton() {
    return clickWidget(WidgetKeys.authSwitchModeKey);
  }

  Future<void> clickSignInWithFacebookButton() async {
    await tester.ensureVisible(find.byKey(WidgetKeys.authSignInWithGoogleKey));
    return clickWidget(WidgetKeys.authSignInWithFbKey);
  }

  Future<void> clickSignInWithGoogleButton() async {
    await tester.ensureVisible(find.byKey(WidgetKeys.authSignInWithGoogleKey));
    return clickWidget(WidgetKeys.authSignInWithGoogleKey);
  }

  Future<void> clickOkInDialog() {
    return clickWidget(WidgetKeys.dialogOkButton);
  }

  Future<void> clickForgotPasswordButton() {
    return clickWidget(WidgetKeys.authForgotPasswordKey);
  }
}
