import 'package:expenses_tracker/core/presentation/widget_keys.dart';

import '../../../core/presentation/base_robot.dart';

class EditProfileRobot extends BaseRobot {
  EditProfileRobot({required super.tester});

  Future<void> enterNewUserName(String userName) {
    return enterText(WidgetKeys.editProfileUsernameKey, userName);
  }

  Future<void> clickEditButton() {
    return clickWidget(WidgetKeys.editProfileSaveKey);
  }
}
