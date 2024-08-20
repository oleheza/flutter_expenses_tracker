import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/domain/formatter/date_time_formatter.dart';
import '../../../core/domain/model/expense_model.dart';
import '../../../core/presentation/adaptive_bottom_popup.dart';
import '../../../core/presentation/adaptive_bottom_popup_action_data.dart';
import '../../../core/presentation/build_context_extensions.dart';
import '../../../core/presentation/widget_keys.dart';
import '../../../core/presentation/widgets/adaptive/adaptive_circle_avatar.dart';
import '../../../core/presentation/widgets/adaptive/adaptive_icon.dart';
import '../../../core/presentation/widgets/adaptive/adaptive_list_tile.dart';
import '../../../core/presentation/widgets/adaptive/adaptive_progress_indicator.dart';
import '../../../core/presentation/widgets/adaptive/adaptive_text.dart';
import '../../../create_or_update_expenses/presentation/create_or_update_expenses_screen.dart';
import '../bloc/expenses_list_bloc.dart';
import '../domain/model/expenses_list_item.dart';
import 'widgets/expenses_amount_widget.dart';

class ExpensesListContent extends StatelessWidget {
  const ExpensesListContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpensesListBloc, ExpensesListState>(
      builder: (ctx, state) {
        final expenses = state.expenses;
        if (expenses == null) {
          return const Center(
            child: AdaptiveProgressIndicator(),
          );
        }
        return expenses.isNotEmpty
            ? _ExpensesList(
                expenses: expenses,
                onItemDeleted: (id) {
                  context
                      .read<ExpensesListBloc>()
                      .add(ExpensesListEvent.deleteItem(id));
                },
              )
            : Center(
                child: Text(context.tr.noExpensesAddYet),
              );
      },
    );
  }
}

class _ExpensesList extends StatelessWidget {
  final DateTimeFormatter _dateTimeFormatter = DateTimeFormatter();
  final List<ExpensesListItem> expenses;
  final Function(String) onItemDeleted;

  _ExpensesList({
    super.key,
    required this.expenses,
    required this.onItemDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        final item = expenses[index];
        return switch (item) {
          ExpensesModelListItem(expenseModel: final model) => _ExpensesListItem(
              expenseModel: model,
              onItemDeleted: onItemDeleted,
            ),
          ExpensesDateListItem(
            dateInMillis: final date,
            language: final language,
          ) =>
            _ExpensesDateListItem(
              formattedDate: _dateTimeFormatter.formatToLongDate(
                DateTime.fromMillisecondsSinceEpoch(date),
                language,
              ),
            ),
        };
      },
      itemCount: expenses.length,
    );
  }
}

class _ExpensesListItem extends StatelessWidget {
  final ExpenseModel expenseModel;
  final Function(String) onItemDeleted;

  const _ExpensesListItem({
    super.key,
    required this.expenseModel,
    required this.onItemDeleted,
  });

  void _showExpensesActionsBottomPopup(
    BuildContext context,
    String expenseId,
  ) {
    showAdaptiveBottomPopup(
      context: context,
      actions: <AdaptiveBottomPopupActionData>[
        AdaptiveBottomPopupActionData(
          key: WidgetKeys.expensesItemMenuEditKey,
          text: context.tr.edit,
          onPress: (ctx) {
            ctx.pop();
            ctx.pushNamed(
              CreateOrUpdateExpensesScreen.screenName,
              extra: expenseId,
            );
          },
        ),
        AdaptiveBottomPopupActionData(
          key: WidgetKeys.expensesItemMenuCancelKey,
          text: context.tr.cancel,
          onPress: (ctx) {
            ctx.pop();
          },
          isDestructiveAction: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(expenseModel.id!),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onItemDeleted(expenseModel.id!);
      },
      background: const _DismissibleBackground(),
      child: AdaptiveListTile(
        leading: AdaptiveCircleAvatar(
          child: AdaptiveIcon(
            material: (_) => MaterialAdaptiveIconData(
              icon: Icons.attach_money,
            ),
            cupertino: (_) => CupertinoAdaptiveIconData(
              icon: CupertinoIcons.money_dollar,
              color: context.cupertinoTheme.primaryContrastingColor,
            ),
          ),
        ),
        title: Text(expenseModel.name),
        trailing: ExpenseAmountWidget(
          expenseModel: expenseModel,
        ),
        onTap: () {},
        onLongPress: () {
          _showExpensesActionsBottomPopup(context, expenseModel.id!);
        },
      ),
    );
  }
}

class _DismissibleBackground extends StatelessWidget {
  const _DismissibleBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.red,
      alignment: Alignment.centerRight,
      child: AdaptiveIcon(
        material: (_) => MaterialAdaptiveIconData(
          icon: Icons.delete,
          color: Colors.white,
        ),
        cupertino: (_) => CupertinoAdaptiveIconData(
          icon: CupertinoIcons.delete,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _ExpensesDateListItem extends StatelessWidget {
  final String formattedDate;

  const _ExpensesDateListItem({
    super.key,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AdaptiveText(
        text: formattedDate,
        textAlign: TextAlign.start,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
    );
  }
}
