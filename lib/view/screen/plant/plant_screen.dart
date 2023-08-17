import 'package:flutter/material.dart';
import 'package:nurserygardenapp/data/model/plant_model.dart';
import 'package:nurserygardenapp/providers/plant_provider.dart';
import 'package:nurserygardenapp/view/base/drawer_widget.dart';
import 'package:nurserygardenapp/view/screen/plant/widget/plant_grid_item.dart';
import 'package:provider/provider.dart';

class PlantScreen extends StatefulWidget {
  const PlantScreen({super.key});

  @override
  State<PlantScreen> createState() => _PlantScreenState();
}

class _PlantScreenState extends State<PlantScreen> {
  late var plant_prov = Provider.of<PlantProvider>(context, listen: false);
  List<Plant> plantList = [];

  @override
  void initState() {
    super.initState();
    getPlantList();
  }

  Future<void> getPlantList() async {
    bool success = await plant_prov.getPlantList();
    if (success) {
      plantList = await plant_prov.plantList;
      print(plantList);
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
        body: Consumer<PlantProvider>(builder: (context, plantProvider, child) {
          return plantProvider.isLoading
              ? Center(child: CircularProgressIndicator())
              : GridView(
                  padding: const EdgeInsets.all(24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  children: [
                    for (final plant in plantList)
                      PlantGridItem(
                        key: ValueKey(plant),
                        plant: plant,
                        onTap: () {},
                      ),
                  ],
                );
        }));
  }
}
