import 'package:flutter/material.dart';
import 'package:nurserygardenapp/util/color_resources.dart';

// ignore: must_be_immutable
class ShippingIcon extends StatefulWidget {
  final IconData icon;
  Color? color;

  ShippingIcon({
    super.key,
    required this.icon,
    this.color,
  });

  @override
  State<ShippingIcon> createState() => _ShippingIconState();
}

class _ShippingIconState extends State<ShippingIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.fromLTRB(0, 10, 15, 10),
      child: Icon(
        widget.icon,
        size: 30,
        color: widget.color ?? ColorResources.COLOR_PRIMARY,
      ),
    );
  }
}
