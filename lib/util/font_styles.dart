import 'package:flutter/material.dart';
import 'package:nurserygardenapp/util/dimensions.dart';

const RubikMedium = TextStyle(
  fontFamily: 'Rubik',
  fontSize: Dimensions.FONT_SIZE_DEFAULT,
  fontWeight: FontWeight.w500,
);

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
