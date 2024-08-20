import 'package:expenses_tracker/core/presentation/build_context_extensions.dart';
import 'package:flutter/material.dart';

import '../core/presentation/base_robot.dart';

class HomeScreenRobot extends BaseRobot {
  final BuildContext context;

  HomeScreenRobot({
    required super.tester,
    required this.context,
  });

  Future<void> clickAllExpensesTab() {
    return clickWidgetWithText(context.tr.allExpenses);
  }

  Future<void> clickProfileTab() {
    return clickWidgetWithText(context.tr.profile);
  }

  Future<void> clickSettingsTab() {
    return clickWidgetWithText(context.tr.settings);
  }

  Future<void> navigateToEditProfile() {
    return clickWidgetWithIcon(Icons.edit);
  }

  Future<void> navigateToAddExpenses() {
    return clickWidgetWithIcon(Icons.add);
  }
}
