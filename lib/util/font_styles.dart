import 'package:flutter/material.dart';
import 'package:nurserygardenapp/util/dimensions.dart';

const RubikMedium = TextStyle(
  fontFamily: 'Rubik',
  fontSize: Dimensions.FONT_SIZE_DEFAULT,
  fontWeight: FontWeight.w500,
);

const title = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: Dimensions.FONT_SIZE_LARGE,
);

const subTitle = TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: Dimensions.FONT_SIZE_DEFAULT,
);

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
