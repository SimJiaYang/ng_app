import 'package:flutter/material.dart';

class EmptyCartItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            height: 150,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 15,
                ),
                Container(
                  width: 20,
                  height: 20,
                  color: Colors.grey[400],
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[400],
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 20,
                      color: Colors.grey[400],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 150,
                      height: 20,
                      color: Colors.grey[400],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 150,
                      height: 20,
                      color: Colors.grey[400],
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
