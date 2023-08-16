import 'package:flutter/material.dart';
import 'package:nurserygardenapp/providers/plant_provider.dart';
import 'package:nurserygardenapp/view/base/drawer_widget.dart';
import 'package:provider/provider.dart';

class PlantScreen extends StatefulWidget {
  const PlantScreen({super.key});

  @override
  State<PlantScreen> createState() => _PlantScreenState();
}

class _PlantScreenState extends State<PlantScreen> {
  late var plant_prov = Provider.of<PlantProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    getPlantList();
  }

  Future<void> getPlantList() async {
    bool success = await plant_prov.getPlantList();
    if (success) {
      // print('Plant List: ${plant_prov.plantList.length}');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Plant',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
      ),
      drawer: DrawerWidget(size: size),
      body: Center(
        child: Text('Plant Screen'),
      ),
    );
  }
}
