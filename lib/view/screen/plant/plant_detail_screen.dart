import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nurserygardenapp/data/model/plant_model.dart';
import 'package:nurserygardenapp/providers/plant_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/view/base/custom_space.dart';
import 'package:provider/provider.dart';

class PlantDetailScreen extends StatefulWidget {
  final String plantID;
  final String isSearch;
  const PlantDetailScreen({
    required this.isSearch,
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
    plant = widget.isSearch == "true"
        ? plant_prov.plantListSearch
            .firstWhere((element) => element.id.toString() == widget.plantID)
        : plant_prov.plantList
            .firstWhere((element) => element.id.toString() == widget.plantID);
    setState(() {
      isLoading = false;
    });
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      showModalBottom(index);
    });
  }

  void showModalBottom(int index) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return index == 0
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 10.0),
                  ],
                ),
                height: MediaQuery.of(context).size.height * 0.5,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('Modal BottomSheet'),
                      ElevatedButton(
                        child: const Text('Close BottomSheet'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              )
            : Container(
                height: MediaQuery.of(context).size.height * 0.5,
                color: Colors.grey,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('Modal BottomSheet'),
                      ElevatedButton(
                        child: const Text('Close BottomSheet'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.white, // <-- SEE HERE
          ),
          backgroundColor: ColorResources.COLOR_PRIMARY,
        ),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: ColorResources.COLOR_PRIMARY,
            currentIndex: _selectedIndex, //New
            onTap: _onItemTapped,
            selectedFontSize: 13,
            selectedIconTheme: IconThemeData(color: Colors.white, size: 20),
            selectedItemColor: Colors.white,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedItemColor: Colors.white,
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedIconTheme: IconThemeData(color: Colors.white, size: 20),
            unselectedFontSize: 13,

            // backgroundColor: ColorResources.COLOR_PRIMARY,
            elevation: 0,
            mouseCursor: SystemMouseCursors.grab,
            items: [
              BottomNavigationBarItem(
                  label: "Add to cart",
                  icon: Icon(
                    Icons.add_shopping_cart_outlined,
                  )),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag), label: "Buy now")
            ]),
        body: SafeArea(
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          color: ColorResources.COLOR_WHITE,
                          width: double.infinity,
                          child: CachedNetworkImage(
                            filterQuality: FilterQuality.high,
                            height: 280,
                            fit: BoxFit.fitHeight,
                            imageUrl: "${plant.imageURL!}",
                            memCacheHeight: 200,
                            memCacheWidth: 200,
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
                              Text("RM ${plant.price!.toStringAsFixed(2)}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                          color: ColorResources.COLOR_PRIMARY)),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Category:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: ColorResources.COLOR_BLACK
                                              .withOpacity(0.8))),
                              HorizontalSpacing(
                                width: 3,
                              ),
                              Text("${plant.categoryName}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          color: ColorResources.COLOR_BLACK
                                              .withOpacity(0.8))),
                              Expanded(child: Container()),
                              Text("Inventory:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: ColorResources.COLOR_BLACK
                                              .withOpacity(0.8))),
                              HorizontalSpacing(
                                width: 3,
                              ),
                              Text("${plant.quantity}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          color: ColorResources.COLOR_BLACK
                                              .withOpacity(0.8)))
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Plant Origin:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: ColorResources.COLOR_BLACK
                                              .withOpacity(0.8))),
                              HorizontalSpacing(
                                width: 3,
                              ),
                              Text(
                                  "${plant.origin!.length > 10 ? plant.origin!.substring(0, 10) + ".." : plant.origin}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          color: ColorResources.COLOR_BLACK
                                              .withOpacity(0.8))),
                              Expanded(child: Container()),
                              Text("Mature Height:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: ColorResources.COLOR_BLACK
                                              .withOpacity(0.8))),
                              HorizontalSpacing(
                                width: 3,
                              ),
                              Text("${plant.matureHeight}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          color: ColorResources.COLOR_BLACK
                                              .withOpacity(0.8)))
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          color: ColorResources.COLOR_WHITE,
                          padding: EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Sunlight Need:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: ColorResources.COLOR_BLACK
                                              .withOpacity(0.8))),
                              HorizontalSpacing(
                                width: 3,
                              ),
                              Text("${plant.sunlightNeed}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          color: ColorResources.COLOR_BLACK
                                              .withOpacity(0.8))),
                              Expanded(child: Container()),
                              Text("Water Need:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: ColorResources.COLOR_BLACK
                                              .withOpacity(0.8))),
                              HorizontalSpacing(
                                width: 3,
                              ),
                              Text("${plant.waterNeed}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          color: ColorResources.COLOR_BLACK
                                              .withOpacity(0.8)))
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
                                          fontSize: 14,
                                          color: ColorResources.COLOR_BLACK
                                              .withOpacity(0.8))),
                              VerticalSpacing(
                                height: 10,
                              ),
                              Text("${plant.description}",
                                  textAlign: TextAlign.justify,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          color: ColorResources.COLOR_BLACK
                                              .withOpacity(0.8))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ));
  }
}
