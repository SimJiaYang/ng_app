import 'package:flutter/material.dart';

class EmptyGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 4,
            child: Center(
              child: Container(
                width: 100,
                color: Colors.grey[400],
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Center(
              child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 110,
                      height: 20,
                      color: Colors.grey[400],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 75,
                      height: 15,
                      color: Colors.grey[400],
                    )
                  ])),
            ),
          )
        ],
      ),
    );
  }
}
