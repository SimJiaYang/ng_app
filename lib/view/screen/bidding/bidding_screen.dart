import 'package:flutter/material.dart';
import 'package:nurserygardenapp/view/base/drawer_widget.dart';

class BiddingScreen extends StatefulWidget {
  const BiddingScreen({super.key});

  @override
  State<BiddingScreen> createState() => _BiddingScreenState();
}

class _BiddingScreenState extends State<BiddingScreen> {
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
          'Bidding',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
      ),
      drawer: DrawerWidget(size: size),
      body: Center(
        child: Text('Bidding Screen'),
      ),
    );
  }
}
