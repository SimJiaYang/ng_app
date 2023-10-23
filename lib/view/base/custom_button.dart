import 'package:flutter/material.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/dimensions.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? btnTxt;
  final Color? backgroundColor;
  final double btnHeight;
  final ButtonStyle? customButtonStyle;
  final TextStyle? customTextStyle;
  CustomButton({
    this.onTap,
    this.btnTxt,
    this.backgroundColor,
    this.btnHeight = 41,
    this.customButtonStyle,
    this.customTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: onTap == null
          ? const Color.fromRGBO(160, 164, 168, 1)
          : backgroundColor == null
              ? Theme.of(context).primaryColor
              : backgroundColor,
      minimumSize: Size(MediaQuery.of(context).size.width, this.btnHeight),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return TextButton(
      onPressed: onTap,
      style: this.customButtonStyle == null
          ? flatButtonStyle
          : this.customButtonStyle,
      child: Text(
        btnTxt ?? "",
        style: this.customTextStyle == null
            ? Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: ColorResources.COLOR_WHITE,
                  fontSize: Dimensions.FONT_SIZE_DEFAULT,
                  fontWeight: FontWeight.w600,
                )
            : customTextStyle,
      ),
    );
  }
}
