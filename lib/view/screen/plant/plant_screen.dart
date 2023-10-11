import 'package:flutter/material.dart';
import 'package:nurserygardenapp/providers/plant_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/routes.dart';

import 'package:nurserygardenapp/view/base/empty_data_widget.dart';
import 'package:nurserygardenapp/view/base/empty_grid_item.dart';
import 'package:nurserygardenapp/view/screen/plant/widget/plant_grid_item.dart';
import 'package:provider/provider.dart';

class PlantScreen extends StatefulWidget {
  const PlantScreen({super.key});

  @override
  State<PlantScreen> createState() => _PlantScreenState();
}

class _PlantScreenState extends State<PlantScreen> {
  late PlantProvider plant_prov =
      Provider.of<PlantProvider>(context, listen: false);

  final _scrollController = ScrollController();
  bool _isFirstTime = true;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Param
  var params = {
    'limit': '8',
  };

  Future<void> _loadData({bool isLoadMore = false}) async {
    if (isLoadMore) {
      setState(() {
        _isFirstTime = false;
      });
    }
    await plant_prov.listOfPlant(context, params, isLoadMore: isLoadMore);
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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: ColorResources.COLOR_PRIMARY,
            title: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.getPlantSearchRoute(),
                );
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Expanded(
                        child: Text(
                      "Search Plant",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 14,
                      ),
                    )),
                    Icon(Icons.search),
                  ]),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                    )),
              )
            ]),
        body: SizedBox(
            height: size.height,
            width: size.width,
            child: SafeArea(
              child: Consumer<PlantProvider>(
                  builder: (context, plantProvider, child) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      plantProvider.plantList.isEmpty &&
                              _isFirstTime &&
                              plantProvider.isLoading
                          ? EmptyWidget(
                              large: true,
                              isLoading: plantProvider.isLoading,
                            )
                          : plantProvider.plantList.isEmpty &&
                                  !plantProvider.isLoading
                              ? Center(
                                  child: Text(
                                    "No Plant",
                                    style: TextStyle(
                                        color: Colors.grey.withOpacity(0.7),
                                        fontSize: 18),
                                  ),
                                )
                              : Expanded(
                                  child: RefreshIndicator(
                                    color: Theme.of(context).primaryColor,
                                    key: _refreshIndicatorKey,
                                    onRefresh: () =>
                                        _loadData(isLoadMore: false),
                                    child: GridView.builder(
                                      primary: false,
                                      shrinkWrap: true,
                                      controller: _scrollController,
                                      physics: const BouncingScrollPhysics(),
                                      // physics:
                                      //     const AlwaysScrollableScrollPhysics(),
                                      itemCount:
                                          plantProvider.plantList.length +
                                              ((plantProvider.isLoading &&
                                                      plantProvider.plantList
                                                              .length >=
                                                          8)
                                                  ? 8
                                                  : plantProvider
                                                          .noMoreDataMessage
                                                          .isNotEmpty
                                                      ? 1
                                                      : 0),
                                      padding: (plantProvider.noMoreDataMessage
                                                  .isNotEmpty &&
                                              !plantProvider.isLoading)
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
                                                    .plantList.length &&
                                            plantProvider
                                                .noMoreDataMessage.isEmpty) {
                                          return EmptyGridItem();
                                        } else if (index ==
                                                plantProvider
                                                    .plantList.length &&
                                            plantProvider
                                                .noMoreDataMessage.isNotEmpty) {
                                          return Container(
                                            height: 150,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Center(
                                              child: Text(
                                                  plantProvider
                                                      .noMoreDataMessage,
                                                  style: TextStyle(
                                                      color: Colors.grey
                                                          .withOpacity(0.5))),
                                            ),
                                          );
                                        } else {
                                          return PlantGridItem(
                                            key: ValueKey(plantProvider
                                                .plantList
                                                .elementAt(index)
                                                .id),
                                            plant: plantProvider.plantList
                                                .elementAt(index),
                                            onTap: () async {
                                              await Navigator.pushNamed(
                                                  context,
                                                  Routes.getPlantDetailRoute(
                                                      plantProvider.plantList
                                                          .elementAt(index)
                                                          .id!
                                                          .toString(),
                                                      "false"));
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                    ]);
              }),
            )));
  }
}
