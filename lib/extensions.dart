import 'package:flutter/material.dart';

extension MySize on int {
  SizedBox get h => SizedBox(
        height: toDouble(),
      );
  SizedBox get w => SizedBox(
        width: toDouble(),
      );

  SizedBox hm(BuildContext context) => SizedBox(
        height: MediaQuery.sizeOf(context).height * this / 100,
      );
  SizedBox wm(BuildContext context) => SizedBox(
        width: MediaQuery.sizeOf(context).width * this / 100,
      );
}
