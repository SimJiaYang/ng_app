import 'package:flutter/material.dart';
import 'package:nurserygardenapp/providers/plant_provider.dart';
import 'package:nurserygardenapp/util/routes.dart';
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

  bool _isEmptyPlant = false;

  final _scrollController = ScrollController();
  // Param
  var params = {
    'limit': '8',
  };

  void _loadData({bool isLoadMore = false}) {
    plant_prov
        .listOfPlant(context, params, isLoadMore: isLoadMore)
        .then((value) => {
              if (plant_prov.plantList.isEmpty)
                {
                  setState(() {
                    _isEmptyPlant = true;
                  })
                }
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
      setState(() {});
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
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
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
        body: Consumer<PlantProvider>(builder: (context, plantProvider, child) {
          if (_isEmptyPlant && plantProvider.plantList.isEmpty) {
            return Center(
                child: Text(
              "No Plant",
              style: TextStyle(color: Colors.grey.withOpacity(0.5)),
            ));
          }
          return SafeArea(
            child: GridView.builder(
              shrinkWrap: true,
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              itemCount: plantProvider.plantList.length +
                  ((plantProvider.isLoading &&
                              plantProvider.plantList.length > 8) ||
                          plantProvider.noMoreDataMessage.isNotEmpty
                      ? 1
                      : 0),
              padding: const EdgeInsets.all(10),
              primary: false,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
                if (index == plantProvider.plantList.length &&
                    plantProvider.noMoreDataMessage.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  );
                } else if (index == plantProvider.plantList.length &&
                    plantProvider.noMoreDataMessage.isNotEmpty) {
                  return Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(plantProvider.noMoreDataMessage,
                          style:
                              TextStyle(color: Colors.grey.withOpacity(0.5))),
                    ),
                  );
                } else {
                  return PlantGridItem(
                    key: ValueKey(plantProvider.plantList.elementAt(index).id),
                    plant: plantProvider.plantList.elementAt(index),
                    onTap: () async {
                      await Navigator.pushNamed(
                          context,
                          Routes.getPlantDetailRoute(plantProvider.plantList
                              .elementAt(index)
                              .id!
                              .toString()));
                    },
                  );
                }
              },
            ),
          );
        }));
  }
}
