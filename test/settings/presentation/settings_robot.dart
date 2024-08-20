import 'package:expenses_tracker/core/presentation/build_context_extensions.dart';
import 'package:expenses_tracker/core/presentation/widget_keys.dart';
import 'package:expenses_tracker/settings/presentation/widgets/language_selection.dart';
import 'package:expenses_tracker/settings/presentation/widgets/settings_item_row.dart';
import 'package:expenses_tracker/settings/presentation/widgets/theme_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../core/presentation/base_robot.dart';

class SettingsRobot extends BaseRobot {
  SettingsRobot({required super.tester});

  Future<void> clickLogoutButton() {
    return clickWidget(WidgetKeys.settingsLogoutButtonKey);
  }

  Future<void> clickDeleteAccountButton() {
    return clickWidget(WidgetKeys.settingsDeleteAccountButtonKey);
  }

  Future<void> cancelAccountDeletion(BuildContext context) {
    return clickWidgetWithText(context.tr.no);
  }

  Future<void> confirmAccountDeletion(BuildContext context) {
    return clickWidgetWithText(context.tr.yesDelete);
  }

  Future<void> changeLanguage(int index) async {
    final widget = find.byType(LanguageSelection);

    expect(widget, findsOneWidget);

    final childrenFinder = find.descendant(
      of: widget,
      matching: find.byWidgetPredicate((widget) => widget is SettingsItemRow),
    );

    expect(childrenFinder, findsNWidgets(2));

    final checkBoxesFinder = find.descendant(
      of: childrenFinder.at(index),
      matching: find.byWidgetPredicate((widget) => widget is Checkbox),
    );

    await tester.tap(checkBoxesFinder.last);
    await tester.pumpAndSettle();
  }

  Future<void> changeTheme(int itemIndex) async {
    final widget = find.byType(ThemeSelection);

    expect(widget, findsOneWidget);

    final childrenFinder = find.descendant(
      of: widget,
      matching: find.byWidgetPredicate((widget) => widget is SettingsItemRow),
    );

    expect(childrenFinder, findsNWidgets(3));

    final checkBoxesFinder = find.descendant(
      of: childrenFinder.at(itemIndex),
      matching: find.byWidgetPredicate((widget) => widget is Checkbox),
    );

    await tester.tap(checkBoxesFinder.last);
    await tester.pumpAndSettle();
  }
}
