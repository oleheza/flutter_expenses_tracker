import 'package:flutter/cupertino.dart';

import '../../../core/presentation/build_context_extensions.dart';
import '../../../core/presentation/widgets/adaptive/adaptive_outlined_text_field.dart';

class ExpensesAmountTextField extends StatefulWidget {
  final double? initialValue;
  final ValueChanged<String?>? onAmountChanged;

  const ExpensesAmountTextField({
    super.key,
    this.initialValue,
    this.onAmountChanged,
  });

  @override
  State<ExpensesAmountTextField> createState() =>
      _ExpensesAmountTextFieldState();
}

class _ExpensesAmountTextFieldState extends State<ExpensesAmountTextField> {
  final _amountTextEditingController = TextEditingController();

  void _updateAmountValue() {
    if (_amountTextEditingController.text.isEmpty &&
        widget.initialValue != null) {
      _amountTextEditingController.text = widget.initialValue.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    _updateAmountValue();
  }

  @override
  void didUpdateWidget(ExpensesAmountTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateAmountValue();
  }

  @override
  void dispose() {
    _amountTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveOutlinedTextField(
      textEditingController: _amountTextEditingController,
      hint: context.tr.enterAmount,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: false,
      ),
      onChanged: widget.onAmountChanged,
      material: (_) => MaterialOutlinedTextFieldData(),
      cupertino: (_) => CupertinoOutlinedTextFieldData(
        clearButtonMode: OverlayVisibilityMode.editing,
      ),
    );
  }
}
