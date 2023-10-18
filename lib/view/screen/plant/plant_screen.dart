import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nurserygardenapp/providers/plant_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/images.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/base/empty_grid_item.dart';
import 'package:nurserygardenapp/view/screen/plant/widget/plant_grid_item.dart';
import 'package:provider/provider.dart';

final List<String> imgList = [
  Images.carousel_first,
  Images.carousel_second,
  Images.carousel_third,
  Images.carousel_fourth
];

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

  final List<Widget> imageSliders = imgList
      .map((item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.asset(item, fit: BoxFit.cover, width: 1000.0),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 20.0),
                          child: Center(
                            child: Text(
                              'No. ${imgList.indexOf(item)} image',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ))
      .toList();

  final CarouselController _controller = CarouselController();
  int current = 0;

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
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.getCartRoute());
                    },
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
              child: RefreshIndicator(
                color: Theme.of(context).primaryColor,
                key: _refreshIndicatorKey,
                onRefresh: () => _loadData(isLoadMore: false),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CarouselSlider(
                        items: imageSliders,
                        carouselController: _controller,
                        options: CarouselOptions(
                            viewportFraction: 1,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            aspectRatio: 2.0,
                            onPageChanged: (index, reason) {
                              setState(() {
                                current = index;
                              });
                            }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: imgList.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () => _controller.animateToPage(entry.key),
                            child: Container(
                              width: 8.0,
                              height: 8.0,
                              margin: EdgeInsets.symmetric(
                                  vertical: 6.0, horizontal: 4.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black)
                                      .withOpacity(
                                          current == entry.key ? 0.9 : 0.4)),
                            ),
                          );
                        }).toList(),
                      ),
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
                                itemBuilder: (BuildContext context, int index) {
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
                                    itemCount: plantProvider.plantList.length +
                                        ((plantProvider.isLoading &&
                                                plantProvider
                                                        .plantList.length >=
                                                    8)
                                            ? 8
                                            : plantProvider.noMoreDataMessage
                                                    .isNotEmpty
                                                ? 1
                                                : 0),
                                    padding: (plantProvider
                                                .noMoreDataMessage.isNotEmpty &&
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
                                              plantProvider.plantList.length &&
                                          plantProvider
                                              .noMoreDataMessage.isEmpty) {
                                        return EmptyGridItem();
                                      } else if (index ==
                                              plantProvider.plantList.length &&
                                          plantProvider
                                              .noMoreDataMessage.isNotEmpty) {
                                        return Container(
                                          height: 150,
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
            )));
  }
}
