import 'package:expenses_tracker/auth/domain/use_case/get_facebook_auth_credentials_use_case.dart';
import 'package:expenses_tracker/core/domain/failure/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/firebase_mocks.mocks.dart';

void main() {
  late GetFacebookAuthCredentialsUseCase getFacebookAuthCredentialsUseCase;
  late FacebookAuth facebookAuth;

  setUp(() {
    provideDummy<Either<Failure, AuthCredential>>(Right(MockAuthCredential()));

    facebookAuth = MockFacebookAuth();
    getFacebookAuthCredentialsUseCase =
        GetFacebookAuthCredentialsUseCase(facebookAuth);
  });

  test('test facebook auth returns correct credentials', () async {
    when(facebookAuth.login()).thenAnswer((_) async => LoginResult(
          status: LoginStatus.success,
          accessToken: AccessToken(
            declinedPermissions: [],
            grantedPermissions: ['email'],
            userId: 'user_id',
            expires: DateTime.now(),
            lastRefresh: DateTime.now(),
            token: 'token',
            applicationId: 'app_id',
            isExpired: false,
            dataAccessExpirationTime: DateTime.now(),
          ),
        ));

    final result = await getFacebookAuthCredentialsUseCase.execute(null);

    verify(facebookAuth.login()).called(1);
    expect(result.getRight().toNullable()?.accessToken, 'token');
  });

  test('test failed facebook auth returns failure', () async {
    when(facebookAuth.login()).thenAnswer((_) async => LoginResult(
          status: LoginStatus.success,
          accessToken: null,
        ));

    final result = await getFacebookAuthCredentialsUseCase.execute(null);

    verify(facebookAuth.login()).called(1);
    expect(result.getLeft().toNullable(), const Failure.genericFailure());
  });
}
