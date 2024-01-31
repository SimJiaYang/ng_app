import 'package:flutter/material.dart';

class EmptyAccountWidget extends StatelessWidget {
  const EmptyAccountWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _emptyRow = Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Container(
        width: double.infinity,
        height: 45,
        color: Colors.grey[300],
      ),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: double.infinity,
                height: 200,
                child: Stack(
                  children: [
                    Container(
                      height: 160,
                      color: Colors.grey[300],
                    ),
                    Positioned(
                        left: 10,
                        top: 100,
                        child: ClipOval(
                          child: SizedBox.fromSize(
                            size: Size.fromRadius(50),
                            child: Container(
                              color: Colors.grey[400],
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              _emptyRow,
              _emptyRow,
              _emptyRow,
              _emptyRow,
              _emptyRow,
              Container(
                width: double.infinity,
                height: 100,
                color: Colors.grey[300],
              ),
              _emptyRow,
              _emptyRow,
            ]),
          ),
        ),
      ),
    );
  }

  // Widget _buildLoadingContainer(double width, double height) {
  //   return Container(
  //     width: width,
  //     height: height,
  //     color: Colors.grey[300],
  //   );
  // }
}
