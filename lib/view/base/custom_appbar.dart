import 'package:flutter/material.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/dimensions.dart';
import 'package:nurserygardenapp/util/font_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButtonExist;
  final bool isActionButtonExist;
  final VoidCallback? onBackPressed;
  final BuildContext context;
  final List<Widget>? actionWidget;
  final bool? isCenter;
  CustomAppBar({
    required this.title,
    this.isBackButtonExist = true,
    this.isActionButtonExist = false,
    this.onBackPressed,
    this.isCenter = true,
    this.actionWidget,
    required this.context,
  }) : assert(isActionButtonExist == false || actionWidget != null,
            'Action widget is required when action button is exist.');

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title,
          style: RubikMedium.copyWith(
              fontSize: Dimensions.FONT_SIZE_LARGE,
              color: Theme.of(context).textTheme.bodyLarge?.color)),
      centerTitle: this.isCenter,
      iconTheme: IconThemeData(
        color: ColorResources.COLOR_BLACK,
      ),
      leading: isBackButtonExist
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 18,
              ),
              color: Theme.of(context).textTheme.bodyLarge?.color,
              onPressed: () => onBackPressed != null
                  ? onBackPressed!()
                  : Navigator.pop(context),
            )
          : null,
      actions: this.isActionButtonExist ? this.actionWidget : null,
      backgroundColor: Theme.of(context).cardColor,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, 50);
}
