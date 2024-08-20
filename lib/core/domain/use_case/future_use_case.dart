import 'package:fpdart/fpdart.dart';

import '../failure/failure.dart';
import 'use_case.dart';

abstract interface class FutureUseCase<P, R>
    implements UseCase<P, Future<Either<Failure, R>>> {}
