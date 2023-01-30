import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TextStyleConst {
  static TextStyle title(BuildContext context) => TextStyle(
        fontSize: 19.sp,
        color: Theme.of(context).colorScheme.primary,
      );
  static TextStyle contentBlack = TextStyle(
    fontSize: 16.sp,
  );
}
