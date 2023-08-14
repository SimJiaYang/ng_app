import 'package:flutter/material.dart';
import 'package:nurserygardenapp/view/base/drawer_widget.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late String modeText;
  late Map<String, Icon> settingsWidget;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
      ),
      drawer: DrawerWidget(size: size),
      body: Center(
        child: Text('Product Screen'),
      ),
    );
  }
}
