import 'package:flutter/material.dart';
import 'package:nurserygardenapp/providers/plant_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/base/custom_appbar.dart';
import 'package:nurserygardenapp/view/base/empty_grid_item.dart';
import 'package:nurserygardenapp/view/screen/plant/widget/plant_grid_item.dart';
import 'package:provider/provider.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

class PlantCategoryResultScreen extends StatefulWidget {
  final String category;
  const PlantCategoryResultScreen({super.key, required this.category});

  @override
  State<PlantCategoryResultScreen> createState() =>
      _PlantCategoryResultScreenState();
}

class _PlantCategoryResultScreenState extends State<PlantCategoryResultScreen> {
  late PlantProvider plant_prov =
      Provider.of<PlantProvider>(context, listen: false);

  final _scrollController = ScrollController();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Param
  var params = {
    'limit': '8',
  };

  Future<void> _loadData({bool isLoadMore = false}) async {
    params['category'] = widget.category;
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
        appBar: CustomAppBar(
          title: widget.category,
          context: context,
          isActionButtonExist: false,
          isBgPrimaryColor: true,
          isBackButtonExist: false,
        ),
        body: SizedBox(
            height: size.height,
            width: size.width,
            child: SafeArea(
              child: RefreshIndicator(
                color: Theme.of(context).primaryColor,
                key: _refreshIndicatorKey,
                onRefresh: () => _loadData(isLoadMore: false),
                child: VsScrollbar(
                  controller: _scrollController,
                  showTrackOnHover: true, // default false
                  isAlwaysShown: true, // default false
                  scrollbarFadeDuration: Duration(
                      milliseconds:
                          500), // default : Duration(milliseconds: 300)
                  scrollbarTimeToFade: Duration(
                      milliseconds:
                          800), // default : Duration(milliseconds: 600)
                  style: VsScrollbarStyle(
                    hoverThickness: 4.0, // default 12.0
                    radius: Radius.circular(10), // default Radius.circular(8.0)
                    thickness: 4.0, // [ default 8.0 ]
                    color: ColorResources
                        .COLOR_PRIMARY, // default ColorScheme Theme
                  ),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Consumer<PlantProvider>(
                            builder: (context, plantProvider, child) {
                          return plantProvider.plantList.isEmpty &&
                                  plantProvider.isLoading
                              ? GridView.builder(
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return EmptyGridItem();
                                  })
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
                                  : GridView.builder(
                                      primary: false,
                                      shrinkWrap: true,
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
                                          ? EdgeInsets.fromLTRB(10, 0, 10, 10)
                                          : EdgeInsets.only(
                                              bottom: 235,
                                              left: 10,
                                              right: 10,
                                              top: 0),
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
                                                      "false",
                                                      'false'));
                                            },
                                          );
                                        }
                                      },
                                    );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}
