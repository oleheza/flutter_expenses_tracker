class AuthUseCaseParams {
  final String email;
  final String password;

  const AuthUseCaseParams({
    required this.email,
    required this.password,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthUseCaseParams &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode => Object.hash(email, password);
}
