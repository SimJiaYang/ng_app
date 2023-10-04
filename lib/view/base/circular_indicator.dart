import 'package:flutter/material.dart';

class CircularProgress extends StatelessWidget {
  final double? width;
  final Color? valueColor;
  final bool? isCenter;

  const CircularProgress(
      {this.width = 4.0, this.valueColor, this.isCenter = true, super.key});

  @override
  Widget build(BuildContext context) {
    CircularProgressIndicator circularProgressIndicator =
        CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
          valueColor ?? Theme.of(context).primaryColor),
    );

    return isCenter!
        ? Center(
            child: circularProgressIndicator,
          )
        : circularProgressIndicator;
  }
}
