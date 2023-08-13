import 'package:flutter/material.dart';
import 'package:nurserygardenapp/util/dimensions.dart';

class VerticalSpacing extends StatelessWidget {
  final double? height;
  const VerticalSpacing({this.height = Dimensions.SPACING_SMALL, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class HorizontalSpacing extends StatelessWidget {
  final double? width;
  const HorizontalSpacing({this.width = Dimensions.SPACING_SMALL, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}
