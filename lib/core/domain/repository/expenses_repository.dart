import '../model/expense_model.dart';

abstract interface class ExpensesRepository {
  Future<String> addItem(ExpenseModel item);

  Future<ExpenseModel> getItemById(String userId, String itemId);

  Future<void> updateItem(ExpenseModel item);

  Future<void> deleteItem(String userId, String id);

  Future<void> deleteAll(String userId);

  Stream<List<ExpenseModel>> expensesStream(
    String userId,
    String orderBy,
    bool descending,
  );
}
