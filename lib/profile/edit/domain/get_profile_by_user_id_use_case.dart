import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../core/domain/failure/failure.dart';
import '../../../core/domain/model/profile_model.dart';
import '../../../core/domain/repository/profile_repository.dart';
import '../../../core/domain/use_case/future_use_case.dart';

@injectable
class GetProfileByUserIdUseCase implements FutureUseCase<String, ProfileModel> {
  final ProfileRepository _profileRepository;

  GetProfileByUserIdUseCase(this._profileRepository);

  @override
  Future<Either<Failure, ProfileModel>> execute(String param) async {
    try {
      final profile = await _profileRepository.getProfile(param);
      return Right(profile);
    } on Exception {
      return const Left(Failure.genericFailure());
    }
  }
}
