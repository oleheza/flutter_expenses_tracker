import '../../base_robot.dart';

class CupertinoDatePickerWidgetRobot extends BaseRobot {
  CupertinoDatePickerWidgetRobot({required super.tester});

  Future<void> clickCancelButton() {
    return clickWidgetWithText('Cancel');
  }
}
