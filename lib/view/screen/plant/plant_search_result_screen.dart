import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/routes.dart';
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
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var _selectedFilterList = "None";

  List<String> _filtertList = ["Price", "Top Sales"];

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
      if (plant_prov.plantListSearch.length < int.parse(params['limit']!)) {
        return;
      } else {
        int currentLimit = int.parse(params['limit']!);
        currentLimit += 8;
        params['limit'] = currentLimit.toString();
        _loadData(isLoadMore: true);
      }
    }
  }

  Future<void> _loadData({bool isLoadMore = false}) async {
    if (isLoadMore) {
      setState(() {
        _isFirstTime = false;
      });
    }
    await plant_prov.searchPlant(context, params, isLoadMore: isLoadMore);
  }

  String sortOrder = "asc";

  void _handleParamChanged(param) {
    params['limit'] = '8';
    params['keyword'] = widget.searchKeyword;
    params['sortOrder'] = param['sortOrder'] ?? "";
    setState(() {
      sortOrder = param['sortOrder'] ?? "asc";
    });
    params['category'] = param['category'] ?? "";
    _loadData();
  }

  void _handleFilterParamChange(param, bool isPrice, bool isSales) {
    params['limit'] = '8';
    params['keyword'] = widget.searchKeyword;
    params['sortOrder'] = param['sortOrder'] ?? "";
    setState(() {
      sortOrder = param['sortOrder'] ?? "asc";
    });
    // Test
    if (isPrice) {
      params['sortBy'] = "price";
    }
    if (isSales) {
      params['category'] = "Desert Rose";
    }
    params['category'] = param['category'] ?? "";
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      // endDrawer: PlantDrawerWidget(
      //     sort: sortOrder,
      //     paramCallback: (p) {
      //       _handleParamChanged(p);
      //     },
      //     size: size,
      //     closeEndDrawer: () {
      //       _scaffoldKey.currentState!.closeEndDrawer();
      //     }),
      appBar: AppBar(
          leading: const BackButton(
            color: Colors.white, // <-- SEE HERE
          ),
          backgroundColor: ColorResources.COLOR_PRIMARY,
          title: InkWell(
            onTap: () {
              // Navigator.pushNamed(
              //   context,
              //   Routes.getPlantSearchRoute(),
              // );
            },
            child: Container(
              width: double.infinity,
              height: 40,
              // decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(4),
              //     border: Border.all()),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Expanded(
                      child: Text(
                    "${"Search Result of \"" + widget.searchKeyword + "\""}",
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
            // IconButton(
            //     onPressed: () {
            //       _scaffoldKey.currentState!.openEndDrawer();
            //     },
            //     icon: Icon(
            //       Icons.filter_alt_off_outlined,
            //       color: Colors.white,
            //     ))
          ]),
      body: SizedBox(
          height: size.height,
          width: size.width,
          child: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: CupertinoSlidingSegmentedControl<String>(
                        backgroundColor: Theme.of(context).cardColor,
                        thumbColor: Theme.of(context).primaryColor,
                        // groupValue: _selectedFilterList,
                        onValueChanged: (value) {
                          setState(() {
                            _selectedFilterList = value!;
                            _selectedFilterList == _filtertList[0]
                                ? _handleFilterParamChange(params, true, false)
                                : _handleFilterParamChange(params, false, true);
                          });
                        },
                        children: {
                          _filtertList[0]: Container(
                            decoration: BoxDecoration(
                              color: _selectedFilterList == _filtertList[0]
                                  ? ColorResources.COLOR_PRIMARY
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            height: 40,
                            child: Center(
                              child: Text(_filtertList[0],
                                  style: TextStyle(
                                    color:
                                        _selectedFilterList == _filtertList[0]
                                            ? Colors.white
                                            : Colors.black,
                                  )),
                            ),
                          ),
                          _filtertList[1]: Container(
                            decoration: BoxDecoration(
                              color: _selectedFilterList == _filtertList[1]
                                  ? ColorResources.COLOR_PRIMARY
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            height: 40,
                            child: Center(
                              child: Text(_filtertList[1],
                                  style: TextStyle(
                                    color:
                                        _selectedFilterList == _filtertList[1]
                                            ? Colors.white
                                            : Colors.black,
                                  )),
                            ),
                          )
                        }),
                  ),
                  Consumer<PlantProvider>(
                      builder: (context, plantProvider, child) {
                    return plantProvider.isLoadingSearch &&
                            plantProvider.endSearchResult.isEmpty &&
                            _isFirstTime
                        ? Expanded(
                            child: GridView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: 8,
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 3 / 4,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return EmptyGridItem();
                                }),
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
                                                  plantProvider.plantListSearch
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
                                        plantProvider.endSearchResult.isEmpty) {
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
                                                  plantProvider.plantListSearch
                                                      .elementAt(index)
                                                      .id!
                                                      .toString(),
                                                  "true",
                                                  'false'));
                                        },
                                      );
                                    }
                                  },
                                ),
                              );
                  }),
                ],
              ),
            ),
          )),
    );
  }
}