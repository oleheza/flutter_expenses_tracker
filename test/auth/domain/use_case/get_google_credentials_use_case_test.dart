import 'package:expenses_tracker/auth/domain/use_case/get_google_auth_credentials_use_case.dart';
import 'package:expenses_tracker/core/domain/failure/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  late MockGoogleSignIn googleSignIn;
  late GetGoogleAuthCredentialsUseCase getGoogleAuthCredentialsUseCase;

  setUp(() {
    googleSignIn = MockGoogleSignIn();
    getGoogleAuthCredentialsUseCase = GetGoogleAuthCredentialsUseCase(
      googleSignIn,
    );
  });

  test('test get google credentials is success', () async {
    final result = await getGoogleAuthCredentialsUseCase.execute(null);

    expect(result.isRight(), true);
  });

  test('test get google credentials returns failure on exception', () async {
    googleSignIn.setIsCancelled(true);
    final result = await getGoogleAuthCredentialsUseCase.execute(null);

    expect(
      result.getLeft().toNullable(),
      const Failure.genericFailure(),
    );
  });
}
