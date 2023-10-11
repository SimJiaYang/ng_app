import 'package:flutter/material.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/base/empty_data_widget.dart';
import 'package:nurserygardenapp/view/base/empty_grid_item.dart';
import 'package:nurserygardenapp/view/screen/plant/widget/plant_grid_item.dart';
import 'package:provider/provider.dart';

import '../../../providers/plant_provider.dart';

class PlantSearchResultScreen extends StatefulWidget {
  final String searchKeyword;
  const PlantSearchResultScreen({super.key, required this.searchKeyword});

  @override
  State<PlantSearchResultScreen> createState() =>
      _PlantSearchResultScreenState();
}

class _PlantSearchResultScreenState extends State<PlantSearchResultScreen> {
  late PlantProvider plant_prov =
      Provider.of<PlantProvider>(context, listen: false);

  final _scrollController = ScrollController();

  // Param
  var params = {
    'limit': '8',
    'keyword': "",
  };

  bool _isFirstTime = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      params['keyword'] = widget.searchKeyword;
      _loadData();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (plant_prov.plantList.length < int.parse(params['limit']!)) return;
      int currentLimit = int.parse(params['limit']!);
      currentLimit += 8;
      params['limit'] = currentLimit.toString();
      _loadData(isLoadMore: true);
    }
  }

  Future<void> _loadData({bool isLoadMore = false}) async {
    if (isLoadMore) {
      setState(() {
        _isFirstTime = false;
      });
    }
    await plant_prov.searchPlant(context, params, isLoadMore: isLoadMore);
    // await plant_prov.listOfPlant(context, params, isLoadMore: isLoadMore);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          leading: const BackButton(
            color: Colors.white, // <-- SEE HERE
          ),
          backgroundColor: ColorResources.COLOR_PRIMARY,
          title: InkWell(
            onTap: () {
              // Navigator.pushNamedAndRemoveUntil(
              //   context,
              //   Routes.getPlantSearchRoute(),
              //   (route) => false,
              // );
            },
            child: Container(
              width: double.infinity,
              height: 40,
              // decoration: BoxDecoration(
              //     // color: Colors.white,
              //     borderRadius: BorderRadius.circular(4),
              //     border: Border.all()),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Expanded(
                      child: Text(
                    widget.searchKeyword,
                    style: TextStyle(
                      // color: Colors.black.withOpacity(0.5),
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  )),
                  // Icon(Icons.search),
                ]),
              ),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.filter_alt_off_outlined,
                  color: Colors.white,
                ))
          ]),
      body: SizedBox(
          width: size.width,
          child: SafeArea(
            child: Consumer<PlantProvider>(
                builder: (context, plantProvider, child) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    plantProvider.isLoadingSearch &&
                            plantProvider.endSearchResult.isEmpty &&
                            _isFirstTime
                        ? EmptyWidget(
                            large: true,
                            isLoading: plantProvider.isLoadingSearch,
                          )
                        : plantProvider.plantListSearch.isEmpty &&
                                !plantProvider.isLoadingSearch
                            ? Center(
                                child: Text(
                                  "No Plant Found",
                                  style: TextStyle(
                                      color: Colors.grey.withOpacity(0.7),
                                      fontSize: 18),
                                ),
                              )
                            : Expanded(
                                child: Center(
                                  child: GridView.builder(
                                    primary: false,
                                    shrinkWrap: true,
                                    controller: _scrollController,
                                    physics: const BouncingScrollPhysics(),
                                    // physics:
                                    //     const AlwaysScrollableScrollPhysics(),
                                    itemCount:
                                        plantProvider.plantListSearch.length +
                                            ((plantProvider.isLoadingSearch &&
                                                    plantProvider
                                                            .plantListSearch
                                                            .length >=
                                                        8)
                                                ? 8
                                                : plantProvider.endSearchResult
                                                        .isNotEmpty
                                                    ? 1
                                                    : 0),
                                    padding: (plantProvider
                                                .endSearchResult.isNotEmpty &&
                                            !plantProvider.isLoadingSearch)
                                        ? EdgeInsets.all(10)
                                        : EdgeInsets.only(
                                            bottom: 235,
                                            left: 10,
                                            right: 10,
                                            top: 10),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 3 / 4,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (index >=
                                              plantProvider
                                                  .plantListSearch.length &&
                                          plantProvider
                                              .endSearchResult.isEmpty) {
                                        return EmptyGridItem();
                                      } else if (index ==
                                              plantProvider
                                                  .plantListSearch.length &&
                                          plantProvider
                                              .endSearchResult.isNotEmpty) {
                                        return Container(
                                          height: 150,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Center(
                                            child: Text(
                                                plantProvider.endSearchResult,
                                                style: TextStyle(
                                                    color: Colors.grey
                                                        .withOpacity(0.5))),
                                          ),
                                        );
                                      } else {
                                        return PlantGridItem(
                                          key: ValueKey(plantProvider
                                              .plantListSearch
                                              .elementAt(index)
                                              .id),
                                          plant: plantProvider.plantListSearch
                                              .elementAt(index),
                                          onTap: () async {
                                            await Navigator.pushNamed(
                                                context,
                                                Routes.getPlantDetailRoute(
                                                    plantProvider
                                                        .plantListSearch
                                                        .elementAt(index)
                                                        .id!
                                                        .toString(),
                                                    "true"));
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                  ]);
            }),
          )),
    );
  }
}
