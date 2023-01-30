
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FadableAppBar extends StatefulWidget {
  const FadableAppBar({
    super.key,
    required double scrollPosition,
    required this.actions,
  }) : _scrollPosition = scrollPosition;

  final double _scrollPosition;
  final List<Widget> actions;

  @override
  State<FadableAppBar> createState() => _FadableAppBarState();
}

class _FadableAppBarState extends State<FadableAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white
          .withOpacity((widget._scrollPosition / 200).clamp(0, 1).toDouble()),
      foregroundColor: widget._scrollPosition < 15.h ? Colors.white : null,
      actions: widget.actions,
    );
  }
}
