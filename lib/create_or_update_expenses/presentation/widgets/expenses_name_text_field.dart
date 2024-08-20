import 'package:flutter/cupertino.dart';

import '../../../core/presentation/build_context_extensions.dart';
import '../../../core/presentation/widgets/adaptive/adaptive_outlined_text_field.dart';

class ExpensesNameTextField extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String?>? onNameChanged;

  const ExpensesNameTextField({
    super.key,
    this.initialValue,
    this.onNameChanged,
  });

  @override
  State<ExpensesNameTextField> createState() => _ExpensesNameTextFieldState();
}

class _ExpensesNameTextFieldState extends State<ExpensesNameTextField> {
  final TextEditingController _expensesNameTextController =
      TextEditingController();

  void _updateTextController() {
    if (widget.initialValue != null) {
      _expensesNameTextController.text = widget.initialValue ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveOutlinedTextField(
      hint: context.tr.enterTheName,
      textEditingController: _expensesNameTextController,
      keyboardType: TextInputType.text,
      onChanged: widget.onNameChanged,
      material: (_) => MaterialOutlinedTextFieldData(),
      cupertino: (_) => CupertinoOutlinedTextFieldData(
        clearButtonMode: OverlayVisibilityMode.editing,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _updateTextController();
  }

  @override
  void didUpdateWidget(ExpensesNameTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateTextController();
  }

  @override
  void dispose() {
    _expensesNameTextController.dispose();
    super.dispose();
  }
}
