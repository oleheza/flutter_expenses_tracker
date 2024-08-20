import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/repository/auth_repository.dart';
import '../../../core/presentation/build_context_extensions.dart';
import '../../../core/presentation/widgets/adaptive/adaptive_app_bar.dart';
import '../../../core/presentation/widgets/adaptive/adaptive_scaffold.dart';
import '../../../core/presentation/widgets/adaptive/adaptive_text.dart';
import '../bloc/edit_profile_bloc.dart';
import '../domain/edit_profile_use_case.dart';
import '../domain/get_profile_by_user_id_use_case.dart';
import 'edit_profile_content.dart';

class EditProfileScreen extends StatelessWidget {
  static const String route = '/edit-profile';
  static const String screenName = 'edit-profile';

  final AuthRepository authRepository;
  final GetProfileByUserIdUseCase getProfileByUserIdUseCase;
  final EditProfileUseCase editProfileUseCase;

  const EditProfileScreen({
    super.key,
    required this.authRepository,
    required this.getProfileByUserIdUseCase,
    required this.editProfileUseCase,
  });

  @override
  Widget build(BuildContext context) {
    final title = AdaptiveText(text: context.tr.editProfile);

    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        material: (_) => MaterialAppBarData(
          title: title,
        ),
        cupertino: (_) => CupertinoAppBarData(
          middle: title,
        ),
      ),
      child: BlocProvider(
        create: (context) => EditProfileBloc(
          authRepository: authRepository,
          getProfileByUserIdUseCase: getProfileByUserIdUseCase,
          editProfileUseCase: editProfileUseCase,
        )..add(const EditProfileEvent.initialized()),
        child: const SafeArea(
          child: EditProfileContent(),
        ),
      ),
    );
  }
}
