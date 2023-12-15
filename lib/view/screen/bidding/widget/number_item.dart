import 'package:flutter/material.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/custom_text_style.dart';

class NumberItem extends StatelessWidget {
  final String amount;
  const NumberItem({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 50,
      width: 100,
      decoration: BoxDecoration(
        color: ColorResources.COLOR_DEFAULT,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Row(
          children: [
            Icon(
              Icons.add,
              color: ColorResources.COLOR_BLACK,
              size: 15,
            ),
            Text(
              "${amount}",
              style: CustomTextStyles(context)
                  .subTitleStyle
                  .copyWith(color: ColorResources.COLOR_BLACK, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
