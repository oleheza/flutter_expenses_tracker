import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../app/config/app_language.dart';
import '../../core/domain/formatter/date_time_formatter.dart';
import '../../core/presentation/adaptive_date_picker.dart';
import '../../core/presentation/build_context_extensions.dart';
import '../../core/presentation/widget_keys.dart';
import '../../core/presentation/widgets/adaptive/adaptive_filled_button.dart';
import '../../core/presentation/widgets/adaptive/adaptive_outlined_text_field.dart';
import '../../core/presentation/widgets/adaptive/adaptive_text_button.dart';
import '../../core/presentation/widgets/vertical_spacer.dart';
import '../bloc/create_or_update_expenses_bloc.dart';
import '../bloc/create_or_update_expenses_date_holder.dart';
import 'widgets/expenses_amount_text_field.dart';
import 'widgets/expenses_name_text_field.dart';

class AddExpensesContent extends StatelessWidget {
  final bool isEdit;

  const AddExpensesContent({
    super.key,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context) {
    void addEvent(BuildContext context, CreateOrUpdateExpensesEvent event) {
      context.read<CreateOrUpdateExpensesBloc>().add(event);
    }

    return BlocListener<CreateOrUpdateExpensesBloc,
        CreateOrUpdateExpensesState>(
      listenWhen: (_, state) => state.expensesSaved,
      listener: (ctx, state) => ctx.pop(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            BlocSelector<CreateOrUpdateExpensesBloc,
                CreateOrUpdateExpensesState, String>(
              selector: (state) => state.name,
              builder: (context, initialName) => ExpensesNameTextField(
                key: WidgetKeys.addExpensesNameKey,
                initialValue: initialName,
                onNameChanged: (name) => addEvent(
                  context,
                  CreateOrUpdateExpensesEvent.nameUpdated(name: name ?? ''),
                ),
              ),
            ),
            const VerticalSpacer(),
            BlocSelector<CreateOrUpdateExpensesBloc,
                CreateOrUpdateExpensesState, double?>(
              selector: (state) => state.amount,
              builder: (context, amount) => ExpensesAmountTextField(
                key: WidgetKeys.addExpensesAmountKey,
                initialValue: amount,
                onAmountChanged: (amount) => addEvent(
                  context,
                  CreateOrUpdateExpensesEvent.amountUpdated(
                      amount: amount ?? ''),
                ),
              ),
            ),
            const VerticalSpacer(),
            BlocSelector<CreateOrUpdateExpensesBloc,
                CreateOrUpdateExpensesState, CreateOrUpdateExpensesDateHolder>(
              selector: (state) => state.dateHolder,
              builder: (context, dateHolder) => _ExpensesDateRow(
                initialDate: dateHolder.date,
                appLanguage: dateHolder.language,
                onDateSelected: (selectedDateTime) {
                  addEvent(
                    context,
                    CreateOrUpdateExpensesEvent.dateUpdated(
                      date: selectedDateTime,
                    ),
                  );
                },
              ),
            ),
            BlocSelector<CreateOrUpdateExpensesBloc,
                CreateOrUpdateExpensesState, bool>(
              selector: (state) => state.isValid,
              builder: (context, isValid) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: AdaptiveFilledButton(
                  key: WidgetKeys.addExpensesSaveKey,
                  enabled: isValid,
                  onClick: () {
                    addEvent(
                        context,
                        const CreateOrUpdateExpensesEvent
                            .createOrUpdateExpenses());
                  },
                  cupertino: (_) => CupertinoFilledButtonData(
                    padding: const EdgeInsets.all(8),
                  ),
                  child: Text(isEdit ? context.tr.edit : context.tr.save),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpensesDateRow extends StatefulWidget {
  final DateTime? initialDate;
  final AppLanguage? appLanguage;
  final ValueChanged<DateTime> onDateSelected;

  const _ExpensesDateRow({
    super.key,
    this.initialDate,
    this.appLanguage,
    required this.onDateSelected,
  });

  @override
  State<_ExpensesDateRow> createState() => _ExpensesDateRowState();
}

class _ExpensesDateRowState extends State<_ExpensesDateRow> {
  late DateTime? _selectedDate;
  late AppLanguage? appLanguage;
  final DateTimeFormatter _dateTimeFormatter = DateTimeFormatter();
  final TextEditingController _dateTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    appLanguage = widget.appLanguage;
    _selectedDate = widget.initialDate;
    if (_selectedDate != null) {
      _dateTextController.text = _formatDate(_selectedDate!);
    }
  }

  @override
  void didUpdateWidget(_ExpensesDateRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    _selectedDate = widget.initialDate;
    if (_selectedDate != null) {
      _dateTextController.text = _formatDate(_selectedDate!);
    }
  }

  @override
  void dispose() {
    _dateTextController.dispose();
    super.dispose();
  }

  void _pickDate(BuildContext context) async {
    final selectedDateTime = await showAdaptiveDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      confirmText: context.tr.confirm,
      cancelText: context.tr.cancel,
    );
    if (context.mounted && selectedDateTime != null) {
      setState(() {
        _selectedDate = selectedDateTime;
      });
      widget.onDateSelected(selectedDateTime);
    }
  }

  String _formatDate(DateTime dateToFormat) {
    return _dateTimeFormatter.formatToLongDate(dateToFormat, appLanguage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: AdaptiveOutlinedTextField(
            hint: context.tr.enterADate,
            textEditingController: _dateTextController,
            isEnabled: false,
          ),
        ),
        AdaptiveTextButton(
          key: WidgetKeys.addExpensesSelectDateKey,
          child: Text(context.tr.select),
          onClick: () {
            _pickDate(context);
          },
        )
      ],
    );
  }
}
