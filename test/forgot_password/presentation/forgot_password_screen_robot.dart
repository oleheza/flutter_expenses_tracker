import 'package:expenses_tracker/core/presentation/widget_keys.dart';

import '../../core/presentation/base_robot.dart';

class ForgotPasswordScreenRobot extends BaseRobot {
  ForgotPasswordScreenRobot({required super.tester});

  Future<void> enterEmail(String email) {
    return enterText(WidgetKeys.forgotPasswordEmailKey, email);
  }

  Future<void> clickResetPassword() {
    return clickWidget(WidgetKeys.forgotPasswordResetKey);
  }

  Future<void> clickOkInDialog() {
    return clickWidget(WidgetKeys.dialogOkButton);
  }
}
