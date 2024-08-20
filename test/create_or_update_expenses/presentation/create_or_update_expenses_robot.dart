import 'package:expenses_tracker/core/presentation/widget_keys.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../core/presentation/base_robot.dart';

class CreateOrUpdateExpensesRobot extends BaseRobot {
  CreateOrUpdateExpensesRobot({required super.tester});

  Future<void> enterExpensesName(String name) {
    return enterText(WidgetKeys.addExpensesNameKey, name);
  }

  Future<void> enterExpensesPrice(String price) {
    return enterText(WidgetKeys.addExpensesAmountKey, price);
  }

  Future<void> clickSaveButton() {
    return clickWidget(WidgetKeys.addExpensesSaveKey);
  }

  Future<void> showDatePicker() {
    return clickWidget(WidgetKeys.addExpensesSelectDateKey);
  }

  Future<void> selectDate(String date, String confirmText) async {
    final dateText = find.text(date);
    await tester.tap(dateText);
    await tester.pump();
    final confirmButton = find.text(confirmText);
    await tester.tap(confirmButton);
    await tester.pumpAndSettle();
  }
}
