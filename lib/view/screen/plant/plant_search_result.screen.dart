import 'package:flutter/material.dart';

class PlantSearchResultScreen extends StatefulWidget {
  const PlantSearchResultScreen({super.key});

  @override
  State<PlantSearchResultScreen> createState() =>
      _PlantSearchResultScreenState();
}

class _PlantSearchResultScreenState extends State<PlantSearchResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Result'),
      ),
    );
  }
}
