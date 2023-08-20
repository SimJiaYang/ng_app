import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nurserygardenapp/data/model/plant_model.dart';
import 'package:nurserygardenapp/providers/plant_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/view/base/custom_space.dart';
import 'package:provider/provider.dart';

class PlantDetailScreen extends StatefulWidget {
  final String plantID;
  const PlantDetailScreen({
    required this.plantID,
    super.key,
  });

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  late var plant_prov = Provider.of<PlantProvider>(context, listen: false);
  late Plant plant = Plant();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      return getPlantInformation();
    });
  }

  getPlantInformation() {
    plant = plant_prov.plantList
        .firstWhere((element) => element.id.toString() == widget.plantID);
    setState(() {
      isLoading = false;
    });
    print(plant.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: []),
        body: Center(
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SafeArea(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: ColorResources.COLOR_WHITE,
                            width: double.infinity,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: "${plant.image!}",
                              memCacheHeight: 400, //this line
                              placeholder: (context, url) => Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Center(
                                    child: CircularProgressIndicator(
                                  color: ColorResources.COLOR_GRAY,
                                )),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            color: ColorResources.COLOR_WHITE,
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${plant.name}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 24,
                                        )),
                                VerticalSpacing(
                                  height: 16,
                                ),
                                Text("RM ${plant.price}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 22,
                                            color:
                                                ColorResources.COLOR_PRIMARY)),
                              ],
                            ),
                          ),
                          VerticalSpacing(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            color: ColorResources.COLOR_WHITE,
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Description",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 20,
                                            color: ColorResources.COLOR_BLACK
                                                .withOpacity(0.8))),
                                VerticalSpacing(
                                  height: 10,
                                ),
                                Text("${plant.description}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: ColorResources.COLOR_BLACK
                                                .withOpacity(0.8))),
                                VerticalSpacing(
                                  height: 16,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
        ));
  }
}
