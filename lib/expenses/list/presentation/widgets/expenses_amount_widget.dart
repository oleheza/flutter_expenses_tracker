import 'package:flutter/material.dart';

import '../../../../core/domain/model/expense_model.dart';
import '../../../../core/presentation/widgets/adaptive/adaptive_text.dart';

class ExpenseAmountWidget extends StatelessWidget {
  final double minWidth;
  final double minHeight;
  final double maxHeight;
  final double maxWidth;
  final ExpenseModel expenseModel;

  const ExpenseAmountWidget({
    super.key,
    this.minWidth = 70,
    this.minHeight = 30,
    this.maxWidth = 100,
    this.maxHeight = 30,
    required this.expenseModel,
  });

  @override
  Widget build(BuildContext context) {
    final color = switch (expenseModel.amount) {
      >= 0 => Colors.green,
      _ => Colors.pink,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: color.withAlpha(40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      constraints: BoxConstraints(
        minHeight: minHeight,
        minWidth: minWidth,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
      ),
      child: AdaptiveText(
        textStyle: TextStyle(
          color: color,
        ),
        text: expenseModel.amount.toStringAsFixed(2),
      ),
    );
  }
}
