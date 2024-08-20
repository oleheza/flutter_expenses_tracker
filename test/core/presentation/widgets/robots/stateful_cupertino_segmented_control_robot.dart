import '../../base_robot.dart';

class StatefulCupertinoSegmentedControlRobot extends BaseRobot {
  StatefulCupertinoSegmentedControlRobot({required super.tester});

  Future<void> selectSegmentWithLabel(String label){
    return clickWidgetWithText(label);
  }

}
