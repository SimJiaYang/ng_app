import 'package:flutter/material.dart';
import 'package:nurserygardenapp/providers/plant_provider.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/base/circular_indicator.dart';
import 'package:nurserygardenapp/view/base/empty_data_widget.dart';
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
          title: Text(
            'Plant',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 18,
            ),
          ),
        ),
        body: SizedBox(
            height: size.height,
            width: size.width,
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
                            large: true, isLoading: plantProvider.isLoading)
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
                                  key: _refreshIndicatorKey,
                                  onRefresh: () => _loadData(isLoadMore: false),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    controller: _scrollController,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: plantProvider.plantList.length +
                                        ((plantProvider.isLoading &&
                                                    plantProvider
                                                            .plantList.length >
                                                        8) ||
                                                plantProvider.noMoreDataMessage
                                                    .isNotEmpty
                                            ? 1
                                            : 0),
                                    padding: EdgeInsets.only(
                                        bottom: 100, left: 10, right: 10),
                                    primary: false,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 3 / 4,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (index ==
                                              plantProvider.plantList.length &&
                                          plantProvider
                                              .noMoreDataMessage.isEmpty) {
                                        return Container(
                                          height: 150,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 3),
                                              CircularProgress(),
                                              SizedBox(height: 3),
                                              Text("loading...."),
                                            ],
                                          ),
                                        );
                                      } else if (index ==
                                              plantProvider.plantList.length &&
                                          plantProvider
                                              .noMoreDataMessage.isNotEmpty) {
                                        return Container(
                                          height: 200,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Center(
                                            child: Text(
                                                plantProvider.noMoreDataMessage,
                                                style: TextStyle(
                                                    color: Colors.grey
                                                        .withOpacity(0.5))),
                                          ),
                                        );
                                      } else {
                                        return PlantGridItem(
                                          key: ValueKey(plantProvider.plantList
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
                                                        .toString()));
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                  ]);
            })));
  }
}
