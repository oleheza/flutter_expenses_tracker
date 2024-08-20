import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateNiceMocks(
  <MockSpec>[
    MockSpec<GoRouter>(),
    MockSpec<SharedPreferences>(),
  ],
)
class ThirdPartyMocks {}
