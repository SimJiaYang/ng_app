import 'package:flutter/material.dart';
import 'package:nurserygardenapp/util/app_constants.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/dimensions.dart';

class CustomDialog extends StatelessWidget {
  final String dialogType;
  final String? customImage;
  final String title;
  final String content;
  final String btnText;
  final String? btnTextCancel;
  final VoidCallback onPressed;
  final Color? dialogColor;
  const CustomDialog(
      {Key? key,
      required this.dialogType,
      this.customImage,
      required this.title,
      required this.content,
      required this.btnText,
      this.btnTextCancel,
      this.dialogColor,
      required this.onPressed})
      : super(key: key);

  Widget handleDialogType() {
    switch (this.dialogType) {
      case AppConstants.DIALOG_SUCCESS:
        return Builder(
            builder: (context) => Icon(
                  Icons.check_circle_outline,
                  color: dialogColor ?? Theme.of(context).primaryColor,
                  size: 60,
                ));
      case AppConstants.DIALOG_FAILED:
        return Builder(
            builder: (context) => Icon(
                  Icons.highlight_off_outlined,
                  color: dialogColor ?? Theme.of(context).primaryColor,
                  size: 60,
                ));
      case AppConstants.DIALOG_ERROR:
        return Builder(
            builder: (context) => Icon(
                  Icons.error_outline,
                  color: dialogColor ?? ColorResources.APPBAR_HEADER_COLOR,
                  size: 60,
                ));
      case AppConstants.DIALOG_INFORMATION:
        return Builder(
            builder: (context) => Icon(
                  Icons.help_outline,
                  color: dialogColor ?? Theme.of(context).primaryColor,
                  size: 60,
                ));
      case AppConstants.DIALOG_ALERT:
        return Builder(
            builder: (context) => Icon(
                  Icons.report_outlined,
                  color: dialogColor ?? Theme.of(context).primaryColor,
                  size: 60,
                ));
      case AppConstants.DIALOG_CONFIRMATION:
        return Builder(
            builder: (context) => Icon(
                  Icons.error_outline,
                  color: dialogColor ?? Theme.of(context).primaryColor,
                  size: 60,
                ));
      case AppConstants.DIALOG_WARNING:
        return Builder(
            builder: (context) => Icon(
                  Icons.warning_amber_outlined,
                  color: dialogColor ?? Theme.of(context).primaryColor,
                  size: 60,
                ));
      case AppConstants.DIALOG_CUSTOM:
        return Builder(
          builder: (context) => Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  this.customImage!,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      default:
        return Builder(
          builder: (context) => Icon(
            Icons.check_circle_outline,
            color: dialogColor ?? Theme.of(context).primaryColor,
            size: 60,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          this.dialogType == AppConstants.DIALOG_CONFIRMATION ? true : false,
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 9,
                ),
                handleDialogType(),
                SizedBox(
                  height: 9,
                ),
                Center(
                  child: Text(
                    this.title,
                    style: TextStyle(
                        fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 9,
                ),
                Text(
                  this.content,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (this.dialogType == AppConstants.DIALOG_CONFIRMATION)
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: ColorResources.COLOR_GREY,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextButton(
                        child: Text(
                          this.btnTextCancel != null
                              ? this.btnTextCancel.toString()
                              : 'cancel',
                          style: TextStyle(
                            color: ColorResources.COLOR_BLACK,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextButton(
                      child: Text(
                        this.btnText,
                        style: TextStyle(color: ColorResources.COLOR_WHITE),
                      ),
                      onPressed: this.onPressed,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
