import 'package:flutter/material.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/custom_text_style.dart';

class CustomItem extends StatefulWidget {
  const CustomItem(
      {super.key,
      required this.onTap,
      required this.title,
      required this.icon});
  final Function() onTap;
  final String title;
  final IconData icon;

  @override
  State<CustomItem> createState() => _CustomItemState();
}

class _CustomItemState extends State<CustomItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: ColorResources.COLOR_PRIMARY,
                size: 35,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                widget.title,
                style:
                    CustomTextStyles(context).titleStyle.copyWith(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
