import 'package:freezed_annotation/freezed_annotation.dart';

import '../../app/config/app_language.dart';

part 'create_or_update_expenses_date_holder.freezed.dart';

@freezed
class CreateOrUpdateExpensesDateHolder with _$CreateOrUpdateExpensesDateHolder {
  const factory CreateOrUpdateExpensesDateHolder({
    DateTime? date,
    AppLanguage? language,
  }) = _CreateOrUpdateExpensesDateHolder;
}
