import 'package:flutter/cupertino.dart';

import 'adaptive/adaptive_text.dart';

class StatefulCupertinoSegmentedControl extends StatefulWidget {
  final List<String> labels;
  final List<String> tabTags;
  final List<Widget> children;
  final EdgeInsetsGeometry? tabsPadding;

  const StatefulCupertinoSegmentedControl({
    super.key,
    this.tabsPadding,
    required this.labels,
    required this.tabTags,
    required this.children,
  })  : assert(labels.length >= 2),
        assert(children.length >= 2),
        assert(tabTags.length >= 2),
        assert(labels.length == children.length),
        assert(tabTags.length == children.length);

  @override
  State<StatefulCupertinoSegmentedControl> createState() =>
      _StatefulCupertinoSegmentedControlState();
}

class _StatefulCupertinoSegmentedControlState
    extends State<StatefulCupertinoSegmentedControl> {
  late String _selectedItem;

  final Map<String, Widget> widgetsMap = {};

  Map<String, Widget> _buildChildren() {
    Map<String, Widget> result = <String, Widget>{};
    for (int i = 0; i < widget.children.length; i++) {
      result[widget.tabTags[i]] = AdaptiveText(text: widget.labels[i]);
    }

    return result;
  }

  void _buildWidgetsMap() {
    for (var i = 0; i < widget.tabTags.length; i++) {
      widgetsMap[widget.tabTags[i]] = widget.children[i];
    }
  }

  @override
  void initState() {
    super.initState();
    _buildWidgetsMap();
    _selectedItem = widget.tabTags.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CupertinoSegmentedControl<String>(
          children: _buildChildren(),
          padding: widget.tabsPadding,
          groupValue: _selectedItem,
          onValueChanged: (value) {
            setState(() {
              _selectedItem = value;
            });
          },
        ),
        Expanded(
          child: widgetsMap[_selectedItem] ?? const SizedBox.shrink(),
        )
      ],
    );
  }
}
