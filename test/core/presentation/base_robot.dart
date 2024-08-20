import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class BaseRobot {
  final WidgetTester tester;

  BaseRobot({required this.tester});

  @protected
  Future<void> enterText(Key key, String text) async {
    final inputField = find.byKey(key);
    expect(inputField, findsOneWidget);
    await tester.enterText(inputField, text);
    await tester.pump();
  }

  @protected
  Future<void> clickWidget(Key key) async {
    final widget = find.byKey(key);
    expect(widget, findsOneWidget);
    await tester.tap(widget);
    await tester.pumpAndSettle();
  }

  @protected
  Future<void> clickWidgetWithText(String text) async {
    final widget = find.text(text);
    expect(widget, findsOneWidget);
    await tester.tap(widget);
    await tester.pump();
  }

  @protected
  Future<void> clickWidgetWithIcon(IconData icon) async {
    final widget = find.byIcon(icon);
    expect(widget, findsOneWidget);
    await tester.tap(widget);
    await tester.pump();
  }

  @protected
  Future<void> dragItem(Key key, Offset offset) async {
    final item = find.byKey(key);
    expect(item, findsOneWidget);
    await tester.drag(item, offset);
    await tester.pumpAndSettle();
  }

  @protected
  Future<void> longPress(Key key) async {
    final item = find.byKey(key);
    expect(item, findsOneWidget);
    await tester.longPress(item);
    await tester.pumpAndSettle();
  }
}
