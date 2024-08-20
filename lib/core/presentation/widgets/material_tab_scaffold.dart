import 'package:flutter/material.dart';

class MaterialTabScaffold extends StatefulWidget {
  final PreferredSizeWidget? appBar;
  final FloatingActionButton? floatingActionButton;
  final List<BottomNavigationBarItem> tabs;
  final Widget Function(BuildContext, int) tabBuilder;
  final ValueChanged<int>? onTabSelected;

  const MaterialTabScaffold({
    super.key,
    this.appBar,
    this.floatingActionButton,
    this.onTabSelected,
    required this.tabs,
    required this.tabBuilder,
  });

  @override
  State<MaterialTabScaffold> createState() => _MaterialTabScaffoldState();
}

class _MaterialTabScaffoldState extends State<MaterialTabScaffold> {
  int currentSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: BottomNavigationBar(
        items: widget.tabs,
        onTap: (index) {
          setState(() {
            currentSelectedIndex = index;
          });
          widget.onTabSelected?.call(index);
        },
        currentIndex: currentSelectedIndex,
      ),
      body: widget.tabBuilder(context, currentSelectedIndex),
    );
  }
}
