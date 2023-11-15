import 'package:flutter/material.dart';

class EmptyAddress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        padding: EdgeInsets.all(10),
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
        child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: size.width * 0.8,
                  height: 20,
                  color: Colors.grey[400],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: size.width * 0.6,
                  height: 20,
                  color: Colors.grey[400],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: size.width * 0.4,
                  height: 20,
                  color: Colors.grey[400],
                ),
              ],
            )),
      ),
    );
  }
}
