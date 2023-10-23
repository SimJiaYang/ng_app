import 'package:flutter/material.dart';

class EmptyOrder extends StatelessWidget {
  const EmptyOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  offset: const Offset(0, 2),
                  blurRadius: 10.0),
            ],
          ),
          height: 150,
          width: double.infinity,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                height: 20,
                width: 100,
                color: Colors.grey[400],
              ),
              Container(
                height: 20,
                width: 130,
                color: Colors.grey[400],
              ),
            ]),
            Spacer(),
            Container(
              height: 20,
              width: 150,
              color: Colors.grey[400],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 20,
              width: 150,
              color: Colors.grey[400],
            ),
            Spacer(),
            Container(
              height: 20,
              width: 100,
              color: Colors.grey[400],
            ),
          ]),
        ));
  }
}
