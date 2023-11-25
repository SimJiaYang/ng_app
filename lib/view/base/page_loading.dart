import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nurserygardenapp/util/color_resources.dart';

class LoadingThreeCircle extends StatelessWidget {
  const LoadingThreeCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.threeArchedCircle(
          color: ColorResources.COLOR_PRIMARY, size: 43),
    );
  }
}
