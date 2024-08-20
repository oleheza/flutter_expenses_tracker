import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../build_context_extensions.dart';
import 'adaptive/adaptive_text_button.dart';

class CupertinoDatePickerWidget extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final CupertinoDatePickerMode datePickerMode;
  final String confirmText;
  final String cancelText;
  final double height;

  const CupertinoDatePickerWidget({
    super.key,
    this.initialDate,
    this.datePickerMode = CupertinoDatePickerMode.date,
    this.height = 300,
    required this.firstDate,
    required this.lastDate,
    required this.confirmText,
    required this.cancelText,
  });

  @override
  State<CupertinoDatePickerWidget> createState() =>
      _CupertinoDatePickerWidgetState();
}

class _CupertinoDatePickerWidgetState extends State<CupertinoDatePickerWidget> {
  DateTime? selectedDate;

  DateTime _createCurrentDate() {
    return DateTime.now().subtract(const Duration(hours: 1));
  }

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate ?? _createCurrentDate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      color: context.cupertinoTheme.barBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AdaptiveTextButton(
                child: Text(widget.cancelText),
                onClick: () {
                  context.pop();
                },
              ),
              AdaptiveTextButton(
                child: Text(widget.confirmText),
                onClick: () {
                  context.pop(selectedDate);
                },
              )
            ],
          ),
          const Divider(),
          Expanded(
            child: CupertinoDatePicker(
              // remove it when the picker is fixed
              // mode != CupertinoDatePickerMode.dateAndTime ||
              // maximumDate == null ||
              // !this.initialDateTime.isAfter(maximumDate!)
              initialDateTime: selectedDate,
              mode: widget.datePickerMode,
              showDayOfWeek: true,
              minimumDate: widget.firstDate,
              maximumDate: widget.lastDate,
              onDateTimeChanged: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
