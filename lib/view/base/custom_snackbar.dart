import 'package:flutter/material.dart';
import 'package:nurserygardenapp/util/app_constants.dart';
import 'package:nurserygardenapp/util/color_resources.dart';

void showCustomSnackBar(
  String message,
  BuildContext context, {
  String type = AppConstants.SNACKBAR_ERROR,
  int displayDuration = 3,
  Color? color,
}) {
  checkType(String type) {
    Map<String, Color> typeMap;
    typeMap = {
      AppConstants.SNACKBAR_SUCCESS: Colors.green,
      AppConstants.SNACKBAR_ERROR: ColorResources.APPBAR_HEADER_COLOR,
      AppConstants.SNACKBAR_WARNING: Colors.yellow,
      AppConstants.SNACKBAR_INFO: ColorResources.COLOR_GREY,
    };
    return typeMap[type] ?? ColorResources.APPBAR_HEADER_COLOR;
  }

  checkIcon(String type) {
    Map<String, IconData> iconMap;
    iconMap = {
      AppConstants.SNACKBAR_SUCCESS: Icons.check_circle_outline_outlined,
      AppConstants.SNACKBAR_ERROR: Icons.highlight_off,
      AppConstants.SNACKBAR_WARNING: Icons.warning_amber_rounded,
      AppConstants.SNACKBAR_INFO: Icons.info_outline_rounded,
    };

    return iconMap[type] ?? Icons.highlight_off;
  }

  final _width = MediaQuery.of(context).size.width;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              checkIcon(type),
              color: color == null ? Colors.white : color,
              size: 18,
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(
                message,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: color == null ? Colors.white : color),
              ),
            ),
          ],
        ),
        width: _width * .95,
        behavior: SnackBarBehavior.floating,
        backgroundColor: checkType(type),
        duration: Duration(seconds: displayDuration),
      ),
    );
}
