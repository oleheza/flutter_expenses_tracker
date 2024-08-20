import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/build_context_extensions.dart';
import '../../../core/presentation/widget_extensions.dart';
import '../../../core/presentation/widget_keys.dart';
import '../../../core/presentation/widgets/adaptive/adaptive_filled_button.dart';
import '../../../core/presentation/widgets/adaptive/adaptive_outlined_text_field.dart';
import '../../../core/presentation/widgets/adaptive/adaptive_text.dart';
import '../../../core/presentation/widgets/vertical_spacer.dart';
import '../bloc/edit_profile_bloc.dart';

class EditProfileContent extends StatefulWidget {
  const EditProfileContent({super.key});

  @override
  State<EditProfileContent> createState() => _EditProfileContentState();
}

class _EditProfileContentState extends State<EditProfileContent> {
  final _userNameTextEditingController = TextEditingController();

  @override
  void dispose() {
    _userNameTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void addEvent(BuildContext context, EditProfileEvent event) {
      context.read<EditProfileBloc>().add(event);
    }

    return MultiBlocListener(
      listeners: <BlocListener>[
        BlocListener<EditProfileBloc, EditProfileState>(
          listenWhen: (previousState, state) =>
              previousState.userName != state.userName,
          listener: (context, state) {
            _userNameTextEditingController.text = state.userName ?? '';
          },
        ),
        BlocListener<EditProfileBloc, EditProfileState>(
          listenWhen: (_, state) => state.isLoading,
          listener: (context, _) {
            widget.showLoader(context, context.tr.loading);
          },
        ),
        BlocListener<EditProfileBloc, EditProfileState>(
          listenWhen: (_, state) => state.updated,
          listener: (context, _) {
            context.popIfCan();
            context.popIfCan();
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AdaptiveOutlinedTextField(
              key: WidgetKeys.editProfileUsernameKey,
              textEditingController: _userNameTextEditingController,
              hint: context.tr.enterUsername,
              onChanged: (text) {
                addEvent(
                  context,
                  EditProfileEvent.userNameUpdated(userName: text),
                );
              },
            ),
            const VerticalSpacer(),
            BlocSelector<EditProfileBloc, EditProfileState, bool>(
              selector: (state) => state.isValid,
              builder: (context, isValid) {
                return AdaptiveFilledButton(
                  key: WidgetKeys.editProfileSaveKey,
                  onClick: () {
                    addEvent(
                      context,
                      const EditProfileEvent.updateProfile(),
                    );
                  },
                  enabled: isValid,
                  child: AdaptiveText(
                    text: context.tr.edit,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
