import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../domain/exceptions/expenses_not_found_exception.dart';
import '../../domain/model/expense_model.dart';
import '../../domain/repository/expenses_repository.dart';

@Injectable(as: ExpensesRepository)
class FirebaseExpensesRepository implements ExpensesRepository {
  static const _expensesCollection = 'expenses';

  final CollectionReference _expenses;

  FirebaseExpensesRepository(FirebaseFirestore firebaseFirestore)
      : _expenses = firebaseFirestore.collection(_expensesCollection);

  @override
  Future<String> addItem(ExpenseModel item) async {
    final reference = await _expenses
        .doc(item.userId)
        .collection(_expensesCollection)
        .add(item.asMap());
    return reference.id;
  }

  @override
  Stream<List<ExpenseModel>> expensesStream(
    String userId,
    String orderBy, [
    bool descending = false,
  ]) {
    return _expenses
        .doc(userId)
        .collection(_expensesCollection)
        .orderBy(orderBy, descending: descending)
        .snapshots()
        .map(
          (event) => event.docs.map((document) {
            final data = document.data();
            return ExpenseModel.fromMap(document.id, data);
          }).toList(),
        );
  }

  @override
  Future<void> deleteItem(String userId, String id) {
    return _expenses
        .doc(userId)
        .collection(_expensesCollection)
        .doc(id)
        .delete();
  }

  @override
  Future<void> deleteAll(String userId) async {
    final allExpensesCollection =
        _expenses.doc(userId).collection(_expensesCollection);

    final allExpenses = await allExpensesCollection.get();

    final allExpensesIds = allExpenses.docs.map((doc) => doc.id);

    final futures = allExpensesIds
        .map((id) => allExpensesCollection.doc(id).delete())
        .toList();

    await Future.wait(futures);

    return _expenses.doc(userId).delete();
  }

  @override
  Future<void> updateItem(ExpenseModel item) async {
    final itemId = item.id;
    if (itemId == null) {
      return;
    }
    return _expenses
        .doc(item.userId)
        .collection(_expensesCollection)
        .doc(itemId)
        .update(item.asMap());
  }

  @override
  Future<ExpenseModel> getItemById(String userId, String itemId) async {
    final documentSnapshot = await _expenses
        .doc(userId)
        .collection(_expensesCollection)
        .doc(itemId)
        .get();

    final data = documentSnapshot.data();
    if (data == null) {
      throw const ExpensesNotFoundException();
    }
    return ExpenseModel.fromMap(itemId, data);
  }
}
