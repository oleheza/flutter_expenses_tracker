import 'package:injectable/injectable.dart';

@injectable
class Validator {
  Validator();

  bool isEmailValid(String email) => email.isNotEmpty && email.contains('@');

  bool isPasswordValid(String password) => password.isNotEmpty;
}
