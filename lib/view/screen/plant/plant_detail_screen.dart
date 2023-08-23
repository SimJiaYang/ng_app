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
                              height: 280,
                              fit: BoxFit.fitHeight,
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
                                          fontSize: 20,
                                        )),
                                VerticalSpacing(
                                  height: 10,
                                ),
                                Text("RM ${plant.price}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Category:",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                color: ColorResources
                                                    .COLOR_BLACK
                                                    .withOpacity(0.8))),
                                    HorizontalSpacing(
                                      width: 5,
                                    ),
                                    Text("${plant.category_name}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                                color: ColorResources
                                                    .COLOR_BLACK
                                                    .withOpacity(0.8))),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Inventory:",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                color: ColorResources
                                                    .COLOR_BLACK
                                                    .withOpacity(0.8))),
                                    HorizontalSpacing(
                                      width: 5,
                                    ),
                                    Text("${plant.quantity}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                                color: ColorResources
                                                    .COLOR_BLACK
                                                    .withOpacity(0.8))),
                                  ],
                                )
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Show Origin
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text("Plant\nOrigin",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                  color: ColorResources
                                                      .COLOR_BLACK
                                                      .withOpacity(0.8))),
                                    ),
                                    VerticalSpacing(
                                      height: 10,
                                    ),
                                    Text("${plant.origin}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                                color: ColorResources
                                                    .COLOR_BLACK
                                                    .withOpacity(0.8))),
                                  ],
                                ),

                                // Sunlight Need
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text("Sunlight\n  Need",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                  color: ColorResources
                                                      .COLOR_BLACK
                                                      .withOpacity(0.8))),
                                    ),
                                    VerticalSpacing(
                                      height: 10,
                                    ),
                                    Text("${plant.sunglightNeed}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                                color: ColorResources
                                                    .COLOR_BLACK
                                                    .withOpacity(0.8))),
                                  ],
                                ),
                                // Water Need
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text("Water\nNeed",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                  color: ColorResources
                                                      .COLOR_BLACK
                                                      .withOpacity(0.8))),
                                    ),
                                    VerticalSpacing(
                                      height: 10,
                                    ),
                                    Text("${plant.waterNeed}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                                color: ColorResources
                                                    .COLOR_BLACK
                                                    .withOpacity(0.8))),
                                  ],
                                ),
                                // Height
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text("Mature\n Height",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                  color: ColorResources
                                                      .COLOR_BLACK
                                                      .withOpacity(0.8))),
                                    ),
                                    VerticalSpacing(
                                      height: 10,
                                    ),
                                    Text("${plant.matureHeight} m",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                                color: ColorResources
                                                    .COLOR_BLACK
                                                    .withOpacity(0.8))),
                                  ],
                                ),
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
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ));
  }
}
