import 'package:expenses_tracker/core/data/repository/firebase_expenses_repository.dart';
import 'package:expenses_tracker/core/domain/exceptions/expenses_not_found_exception.dart';
import 'package:expenses_tracker/core/domain/model/expense_model.dart';
import 'package:expenses_tracker/core/domain/repository/expenses_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fake_data/fake_data.dart';

void main() {
  late ExpensesRepository expensesRepository;

  setUp(() {
    expensesRepository = FirebaseExpensesRepository(FakeFirebaseFirestore());
  });

  test(
    'test repository adds items properly',
    () async {
      final id = await expensesRepository.addItem(fakeExpensesModel);

      final addedItem = await expensesRepository.getItemById(
        fakeExpensesModel.userId,
        id,
      );

      expect(fakeExpensesModel.userId == addedItem.userId, isTrue);
      expect(fakeExpensesModel.name == addedItem.name, isTrue);
      expect(fakeExpensesModel.timestamp == addedItem.timestamp, isTrue);
      expect(fakeExpensesModel.amount == addedItem.amount, isTrue);
    },
  );

  test(
    'test repository updates item properly',
    () async {
      final id = await expensesRepository.addItem(fakeExpensesModel);

      final expensesModelWithId = fakeExpensesModel.copyWith(id: id);
      final updatedExpensesModel = expensesModelWithId.copyWith(
        name: 'updated expenses',
      );

      await expensesRepository.updateItem(updatedExpensesModel);

      final updatedExpensesModelFromStorage =
          await expensesRepository.getItemById(
        fakeExpensesModel.userId,
        updatedExpensesModel.id!,
      );

      expect(updatedExpensesModel == updatedExpensesModelFromStorage, isTrue);
    },
  );

  test(
    'test repository deletes item properly',
    () async {
      final id = await expensesRepository.addItem(fakeExpensesModel);
      await expensesRepository.deleteItem(fakeExpensesModel.userId, id);
      expect(
        () => expensesRepository.getItemById(fakeProfile.userId, id),
        throwsA(isA<ExpensesNotFoundException>()),
      );
    },
  );

  test(
    'test repository deletes all items properly',
    () async {
      final id1 = await expensesRepository.addItem(fakeExpensesModel);
      final id2 = await expensesRepository.addItem(fakeExpensesModel);

      await expensesRepository.deleteAll(fakeUser.uid!);

      expect(
        () => expensesRepository.getItemById(fakeProfile.userId, id1),
        throwsA(isA<ExpensesNotFoundException>()),
      );

      expect(
        () => expensesRepository.getItemById(fakeProfile.userId, id2),
        throwsA(isA<ExpensesNotFoundException>()),
      );
    },
  );

  test(
    'test expenses stream emits correct items',
    () async {
      final stream = expensesRepository.expensesStream(
        fakeUser.uid!,
        ExpenseModel.fieldTimestamp,
        true,
      );

      final id1 = await expensesRepository.addItem(fakeExpensesModel);
      final id2 = await expensesRepository.addItem(fakeExpensesModel);

      final newExpensesModel1 = fakeExpensesModel.copyWith(id: id1);
      final newExpensesModel2 = fakeExpensesModel.copyWith(id: id2);

      expectLater(
        stream,
        emitsInOrder(
          [
            [newExpensesModel1, newExpensesModel2],
            [newExpensesModel2],
            []
          ],
        ),
      );

      await expensesRepository.deleteItem(fakeExpensesModel.userId, id1);
      await expensesRepository.deleteItem(fakeExpensesModel.userId, id2);
    },
  );
}
