import 'package:flutter/material.dart';

class EmptyItem extends StatelessWidget {
  const EmptyItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 5),
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[400],
            ),
          ),
        ),
        // Container(
        //   height: 30,
        //   width: 100,
        // ),
      ],
    );
  }
}
