import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../core/domain/failure/failure.dart';
import '../../../core/domain/model/profile_model.dart';
import '../../../core/domain/repository/profile_repository.dart';
import '../../../core/domain/use_case/future_use_case.dart';

@injectable
class EditProfileUseCase implements FutureUseCase<ProfileModel, void> {
  final ProfileRepository _profileRepository;

  EditProfileUseCase(this._profileRepository);

  @override
  Future<Either<Failure, void>> execute(ProfileModel param) async {
    try {
      _profileRepository.updateProfile(param);
      return const Right(null);
    } on Exception {
      return const Left(Failure.genericFailure());
    }
  }
}
