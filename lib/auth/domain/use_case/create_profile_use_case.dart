import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../core/domain/failure/failure.dart';
import '../../../core/domain/model/profile_model.dart';
import '../../../core/domain/repository/profile_repository.dart';
import '../../../core/domain/use_case/future_use_case.dart';

@injectable
class CreateProfileUseCase implements FutureUseCase<ProfileModel, void> {
  final ProfileRepository profileRepository;

  CreateProfileUseCase({
    required this.profileRepository,
  });

  @override
  Future<Either<Failure, void>> execute(ProfileModel param) async {
    try {
      profileRepository.createProfile(param);
      return const Right(null);
    } on Exception {
      return const Left(Failure.genericFailure());
    }
  }
}
