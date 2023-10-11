import 'package:flutter/material.dart';

class PlantDrawerWidget extends StatefulWidget {
  const PlantDrawerWidget({super.key, required this.size});

  final Size size;

  @override
  State<PlantDrawerWidget> createState() => _PlantDrawerWidgetState();
}

class _PlantDrawerWidgetState extends State<PlantDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: widget.size.width * 0.60,
        child: Drawer(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(0)),
            ),
            child: Container(
              height: widget.size.height,
              color: Colors.white,
              child: Text('Drawer'),
            )),
      ),
    );
  }
}
