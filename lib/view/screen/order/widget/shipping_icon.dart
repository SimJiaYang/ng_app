import 'package:flutter/material.dart';
import 'package:nurserygardenapp/util/color_resources.dart';

class ShippingIcon extends StatelessWidget {
  final IconData icon;
  Color? color;

  ShippingIcon({
    super.key,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.fromLTRB(0, 10, 15, 10),
      child: Icon(
        icon,
        size: 30,
        color: color ?? ColorResources.COLOR_PRIMARY,
      ),
    );
  }
}
