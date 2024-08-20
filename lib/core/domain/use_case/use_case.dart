abstract interface class UseCase<P, R> {
  R execute(P param);
}
