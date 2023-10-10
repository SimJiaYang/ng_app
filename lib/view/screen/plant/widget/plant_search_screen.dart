import 'package:flutter/material.dart';

class PlantSearchScreen extends StatefulWidget {
  @override
  _PlantSearchScreenState createState() => _PlantSearchScreenState();
}

class _PlantSearchScreenState extends State<PlantSearchScreen> {
  List<String> _plants = [
    'Rose',
    'Lily',
    'Tulip',
    'Daisy',
    'Sunflower',
    'Orchid',
    'Carnation',
    'Chrysanthemum',
    'Hydrangea',
    'Peony',
  ];

  List<String> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) {
            setState(() {
              _searchResults = _plants
                  .where((plant) =>
                      plant.toLowerCase().contains(value.toLowerCase()))
                  .toList();
            });
          },
          decoration: InputDecoration(
            hintText: 'Search Plants',
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_searchResults[index]),
          );
        },
      ),
    );
  }
}
