import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nurserygardenapp/providers/plant_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/custom_text_style.dart';

import 'package:nurserygardenapp/view/base/circular_indicator.dart';
import 'package:nurserygardenapp/view/base/custom_appbar.dart';

import 'package:provider/provider.dart';

class PlantCategoryScreen extends StatefulWidget {
  const PlantCategoryScreen({super.key});

  @override
  State<PlantCategoryScreen> createState() => _PlantCategoryScreenState();
}

class _PlantCategoryScreenState extends State<PlantCategoryScreen> {
  late PlantProvider plant_prov =
      Provider.of<PlantProvider>(context, listen: false);

  final _scrollController = ScrollController();

  // Param
  var params = {
    'limit': '8',
  };

  Future<void> _loadData({bool isLoadMore = false}) async {
    await plant_prov.getPlantCategory(context, params, isLoadMore: isLoadMore);
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Plant Category',
        context: context,
        isActionButtonExist: false,
        isBgPrimaryColor: true,
        isBackButtonExist: false,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child:
            Consumer<PlantProvider>(builder: (context, plantProvider, child) {
          return plantProvider.isLoadingCategory &&
                  plantProvider.categoryList.isEmpty
              ? CircularProgress()
              : plantProvider.categoryList.isEmpty &&
                      !plantProvider.isLoadingCategory
                  ? Center(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'No Category Found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Stack(children: [
                      ListView.builder(
                          padding: (plantProvider
                                          .endCategoryResult.isNotEmpty &&
                                      !plantProvider.isLoadingCategory ||
                                  (plantProvider.endCategoryResult.isEmpty &&
                                      plantProvider.categoryList.length < 8))
                              ? EdgeInsets.fromLTRB(10, 0, 10, 10)
                              : EdgeInsets.only(
                                  bottom: 20, left: 10, right: 10, top: 0),
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          controller: _scrollController,
                          itemCount: plantProvider.categoryList.length +
                              ((plantProvider.isLoading &&
                                      plantProvider.categoryList.length >= 8)
                                  ? 1
                                  : plantProvider.categoryList.isNotEmpty
                                      ? 1
                                      : 0),
                          itemBuilder: (context, index) {
                            if (index >= plantProvider.categoryList.length &&
                                plantProvider.endCategoryResult.isEmpty) {
                              return Center(
                                  child: LoadingAnimationWidget.waveDots(
                                      color: ColorResources.COLOR_PRIMARY,
                                      size: 40));
                            } else if (index >=
                                    plantProvider.categoryList.length &&
                                plantProvider.endCategoryResult.isNotEmpty) {
                              return Container(
                                height: 50,
                              );
                            } else {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            offset: const Offset(0, 2),
                                            blurRadius: 10.0),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            plantProvider
                                                .categoryList[index].name!,
                                            style: CustomTextStyles(context)
                                                .subTitleStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          }),
                    ]);
        }),
      ),
    );
  }
}
