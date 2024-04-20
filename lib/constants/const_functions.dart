import 'package:chatroom/constants/constants.dart';
import 'package:flutter/material.dart';

TextStyle urbanist(Color color, {double? fontsize = fontSizeMedium, FontWeight? weight = FontWeight.w400, double letterSpacing = 0}) {
  return TextStyle(
    color: color,
    fontFamily: 'Urbanist',
    fontSize: fontsize,
    letterSpacing: letterSpacing,
    fontWeight: weight,
  );
}

// Padding defaults
EdgeInsets setPadding({double left = 16, double right = 16, double top = 0, double bottom = 0}) {
  return EdgeInsets.only(left: left, right: right, top: top, bottom: bottom);
}
