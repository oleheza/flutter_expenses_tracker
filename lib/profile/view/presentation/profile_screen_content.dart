import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/build_context_extensions.dart';
import '../../../core/presentation/widgets/adaptive/adaptive_text.dart';
import '../bloc/profile_cubit.dart';

class ProfileScreenContent extends StatelessWidget {
  const ProfileScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ProfileDataItem(
                label: context.tr.email,
                value: state.email ?? '',
              ),
              const Divider(),
              ProfileDataItem(
                label: context.tr.userName,
                value: state.userName ?? '',
              )
            ],
          ),
        );
      },
    );
  }
}

class ProfileDataItem extends StatelessWidget {
  final String label;
  final String value;

  const ProfileDataItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AdaptiveText(
          text: label,
          textAlign: TextAlign.left,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        AdaptiveText(
          text: value,
          textAlign: TextAlign.left,
          textStyle: const TextStyle(
            fontSize: 18,
          ),
        )
      ],
    );
  }
}
