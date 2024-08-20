import 'package:expenses_tracker/core/presentation/widget_keys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../core/presentation/base_robot.dart';

class ExpensesListRobot extends BaseRobot {
  ExpensesListRobot({required super.tester});

  Future<void> dismissExpensesItem(String itemId) async {
    return dragItem(Key(itemId), const Offset(-500, 0));
  }

  Future<void> longPressOnItem(String itemId) async {
    return longPress(Key(itemId));
  }

  Future<void> clickEditButton() {
    return clickWidget(WidgetKeys.expensesItemMenuEditKey);
  }

  Future<void> clickCancelButton() {
    return clickWidget(WidgetKeys.expensesItemMenuCancelKey);
  }
}
