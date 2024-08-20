import 'package:expenses_tracker/core/domain/repository/auth_repository.dart';
import 'package:expenses_tracker/core/domain/repository/expenses_repository.dart';
import 'package:expenses_tracker/core/domain/repository/profile_repository.dart';
import 'package:expenses_tracker/core/domain/repository/settings_repository.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks(
  <MockSpec>[
    MockSpec<AuthRepository>(),
    MockSpec<SettingsRepository>(),
    MockSpec<ProfileRepository>(),
    MockSpec<ExpensesRepository>()
  ],
)
class RepositoryMocks {}
