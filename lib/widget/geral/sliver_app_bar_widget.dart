import 'package:flutter/material.dart';

class SliverAppBarWidget extends StatelessWidget {
  final Widget title;
  final Widget leading;
  final Widget flexibleSpace;
  final List<Widget> actions;
  final double expandedHeight;
  final IconThemeData iconTheme;
  final bool pinned;
  final bool floating;
  final bool snap;
  final double elevation;
  final bool centerTitle;
  final Brightness brightness;

  SliverAppBarWidget({
    this.title,
    this.actions,
    this.flexibleSpace,
    this.leading,
    this.iconTheme,
    this.expandedHeight: kToolbarHeight,
    this.pinned: false,
    this.floating: true,
    this.snap: true,
    this.elevation,
    this.centerTitle: true,
    this.brightness,
  }): assert((title != null && flexibleSpace == null) || (title == null && flexibleSpace != null));

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: floating,
      snap: snap,
      pinned: pinned,
      expandedHeight: expandedHeight,
      centerTitle: centerTitle,
      elevation: elevation ?? Theme.of(context).appBarTheme.elevation,
      forceElevated: true,
      iconTheme: iconTheme,
      brightness: brightness,
      title: title,
      leading: leading,
      flexibleSpace: flexibleSpace,
      actions: actions,
    );
  }
}
