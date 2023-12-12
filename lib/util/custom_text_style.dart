import 'package:flutter/material.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/dimensions.dart';

class CustomTextStyles {
  late BuildContext context;

  CustomTextStyles(BuildContext context) {
    this.context = context;
  }

  TextStyle get titleStyle {
    var theme = Theme.of(context).textTheme;
    return theme.headlineMedium!.copyWith(
      fontSize: Dimensions.FONT_SIZE_DEFAULT,
      color: ColorResources.COLOR_BLACK.withOpacity(0.8),
    );
  }

  TextStyle get subTitleStyle {
    var theme = Theme.of(context).textTheme;
    return theme.headlineMedium!.copyWith(
      fontSize: Dimensions.FONT_SIZE_DEFAULT,
      color: const Color.fromRGBO(45, 45, 45, 1).withOpacity(0.6),
    );
  }
}
