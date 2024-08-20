import 'package:expenses_tracker/auth/domain/use_case/params/auth_use_case_params.dart';
import 'package:expenses_tracker/core/domain/model/expense_model.dart';
import 'package:expenses_tracker/core/domain/model/profile_model.dart';
import 'package:expenses_tracker/core/domain/model/user_model.dart';

const fakeEmail = 'user@email.com';
const fakePassword = '123';
const fakeAuthUseCaseParams = AuthUseCaseParams(
  email: fakeEmail,
  password: fakePassword,
);

final fakeUser = UserModel(
  uid: '1212',
  email: 'user@email.com',
  displayName: '',
  photoUrl: '',
);

final fakeProfile = ProfileModel(
  id: null,
  userId: fakeUser.uid ?? '',
  email: fakeUser.email ?? '',
  userName: 'user',
);

final fakeExpensesModel = ExpenseModel(
  id: '443545',
  userId: fakeUser.uid!,
  name: 'fake expenses',
  timestamp: DateTime.now().millisecondsSinceEpoch,
  amount: -100,
);
