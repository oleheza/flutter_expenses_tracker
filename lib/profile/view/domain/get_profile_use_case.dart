import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../core/domain/exceptions/profile_not_found_exception.dart';
import '../../../core/domain/failure/failure.dart';
import '../../../core/domain/model/profile_model.dart';
import '../../../core/domain/repository/profile_repository.dart';
import '../../../core/domain/use_case/future_use_case.dart';

@injectable
class GetProfileUseCase implements FutureUseCase<String, ProfileModel?> {
  final ProfileRepository profileRepository;

  GetProfileUseCase({
    required this.profileRepository,
  });

  @override
  Future<Either<Failure, ProfileModel?>> execute(String param) async {
    try {
      final profile = await profileRepository.getProfile(param);

      return Right(profile);
    } on ProfileNotFoundException {
      return const Left(Failure.profileNotFound());
    } on Exception {
      return const Left(Failure.genericFailure());
    }
  }
}
