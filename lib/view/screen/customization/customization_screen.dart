import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nurserygardenapp/providers/customize_provider.dart';
import 'package:nurserygardenapp/util/app_constants.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/dimensions.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/base/page_loading.dart';
import 'package:provider/provider.dart';

class CustomizationScreen extends StatefulWidget {
  const CustomizationScreen({super.key});

  @override
  State<CustomizationScreen> createState() => _CustomizationScreenState();
}

class _CustomizationScreenState extends State<CustomizationScreen> {
  late CustomizeProvider custom_prov = Provider.of(context, listen: false);
  ScrollController _plantController = ScrollController();
  ScrollController _productController = ScrollController();
  ScrollController _soilController = ScrollController();
  int _currentStep = 0;

  var plant_params = {
    'limit': '8',
    'category': AppConstants.DESERT_ROSE,
  };

  var product_params = {
    'limit': '8',
    'category': AppConstants.POT,
  };

  Future<void> _loadPlant({bool isLoadMore = false}) async {
    await custom_prov.listOfPlant(context, plant_params,
        isLoadMore: isLoadMore);
  }

  Future<void> _loadProduct({bool isLoadMore = false}) async {
    await custom_prov.listOfProduct(context, product_params,
        isLoadMore: isLoadMore);
  }

  void _plantScroll() {
    if (_plantController.position.pixels ==
        _plantController.position.maxScrollExtent) {
      if (custom_prov.plantList.length < int.parse(plant_params['limit']!))
        return;
      int currentLimit = int.parse(plant_params['limit']!);
      currentLimit += 8;
      plant_params['limit'] = currentLimit.toString();
      _loadPlant(isLoadMore: true);
    }
  }

  void _productScroll() {
    if (_productController.position.pixels ==
        _productController.position.maxScrollExtent) {
      if (custom_prov.productList.length < int.parse(product_params['limit']!))
        return;
      int currentLimit = int.parse(product_params['limit']!);
      currentLimit += 8;
      product_params['limit'] = currentLimit.toString();
      _loadProduct(isLoadMore: true);
    }
  }

  @override
  void initState() {
    super.initState();
    _plantController.addListener(_plantScroll);
    _productController.addListener(_productScroll);
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPlant();
      _loadProduct();
    });
  }

  @override
  void dispose() {
    _plantController.dispose();
    _productController.dispose();
    _soilController.dispose();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void tapped(int step) {
    // If in add mode, only allow to go to next step
    setState(() => _currentStep = step);
  }

  void continued() {
    FocusScope.of(context).unfocus();
    _currentStep < 3 ? setState(() => _currentStep += 1) : _handleSubmit();
  }

  void cancel() {
    FocusScope.of(context).unfocus();
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  _handleSubmit() {}

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var theme = Theme.of(context).textTheme;
    TextStyle _title = theme.headlineMedium!.copyWith(
      fontSize: Dimensions.FONT_SIZE_DEFAULT,
      color: ColorResources.COLOR_BLACK.withOpacity(0.8),
    );
    TextStyle _subTitle = theme.headlineMedium!.copyWith(
      fontSize: Dimensions.FONT_SIZE_DEFAULT,
      color: ColorResources.COLOR_BLACK.withOpacity(0.6),
    );

    Widget _plantBuilder =
        Consumer<CustomizeProvider>(builder: (context, customProvider, child) {
      return customProvider.isLoading && customProvider.plantList.isEmpty
          ? Container(height: 150, child: Loading())
          : customProvider.plantList.isEmpty && !customProvider.isLoading
              ? Center(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'No Plant Data Available',
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
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Plant',
                      style: _title,
                    ),
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      height: 200,
                      // height: size.height * 0.5,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: (customProvider.plantNoMoreData.isNotEmpty &&
                                      !customProvider.isLoading ||
                                  (customProvider.plantNoMoreData.isEmpty &&
                                      customProvider.plantList.length < 8))
                              ? EdgeInsets.fromLTRB(0, 0, 10, 0)
                              : EdgeInsets.fromLTRB(0, 0, 50, 0),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          controller: _plantController,
                          itemCount: customProvider.plantList.length +
                              ((customProvider.isLoading &&
                                      customProvider.plantList.length >= 8)
                                  ? 1
                                  : customProvider.plantNoMoreData.isNotEmpty
                                      ? 1
                                      : 0),
                          itemBuilder: (context, index) {
                            if (index >= customProvider.plantList.length &&
                                customProvider.plantNoMoreData.isEmpty) {
                              return Center(
                                child: LoadingAnimationWidget.waveDots(
                                    color: ColorResources.COLOR_PRIMARY,
                                    size: 40),
                              );
                            } else if (index >=
                                    customProvider.plantList.length &&
                                customProvider.plantNoMoreData.isNotEmpty) {
                              // return Container(
                              //   height: 50,
                              // );
                            } else {
                              return Center(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 150,
                                        width: 150,
                                        child: CachedNetworkImage(
                                          filterQuality: FilterQuality.high,
                                          imageUrl:
                                              "${customProvider.plantList[index].imageURL}",
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              width: double.infinity,
                                              height: 20,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          }),
                    ),
                  ],
                );
    });

    Widget _productBuilder =
        Consumer<CustomizeProvider>(builder: (context, customProvider, child) {
      return customProvider.isLoading && customProvider.productList.isEmpty
          ? Container(height: 150, child: Loading())
          : customProvider.productList.isEmpty && !customProvider.isLoading
              ? Center(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'No Product Data Available',
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
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Pot',
                      style: _title,
                    ),
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      height: 200,
                      // height: size.height * 0.5,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: (customProvider
                                          .productNoMoreData.isNotEmpty &&
                                      !customProvider.isLoading ||
                                  (customProvider.productNoMoreData.isEmpty &&
                                      customProvider.productList.length < 8))
                              ? EdgeInsets.fromLTRB(0, 0, 10, 0)
                              : EdgeInsets.fromLTRB(0, 0, 50, 0),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          controller: _productController,
                          itemCount: customProvider.productList.length +
                              ((customProvider.isLoading &&
                                      customProvider.productList.length >= 8)
                                  ? 1
                                  : customProvider.productNoMoreData.isNotEmpty
                                      ? 1
                                      : 0),
                          itemBuilder: (context, index) {
                            if (index >= customProvider.productList.length &&
                                customProvider.productNoMoreData.isEmpty) {
                              return Center(
                                child: LoadingAnimationWidget.waveDots(
                                    color: ColorResources.COLOR_PRIMARY,
                                    size: 40),
                              );
                            } else if (index >=
                                    customProvider.productList.length &&
                                customProvider.productNoMoreData.isNotEmpty) {
                              // return Container(
                              //   height: 50,
                              // );
                            } else {
                              return Center(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 150,
                                        width: 150,
                                        child: CachedNetworkImage(
                                          filterQuality: FilterQuality.high,
                                          imageUrl:
                                              "${customProvider.productList[index].imageURL}",
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              width: double.infinity,
                                              height: 20,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          }),
                    ),
                  ],
                );
    });

    return Scaffold(
        appBar: AppBar(
            backgroundColor: ColorResources.COLOR_PRIMARY,
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text("Customization",
                  style: _title.copyWith(
                      color: ColorResources.COLOR_WHITE, fontSize: 16)),
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
        body: Container(
          color: Colors.white,
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Stepper(
                  connectorColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return ColorResources.COLOR_GREY;
                    }
                    return ColorResources.COLOR_PRIMARY;
                  }),
                  elevation: 0,
                  type: StepperType.horizontal,
                  physics: BouncingScrollPhysics(),
                  currentStep: _currentStep,
                  onStepTapped: (step) => tapped(step),
                  onStepContinue: continued,
                  onStepCancel: cancel,
                  controlsBuilder: (context, details) {
                    if (_currentStep <= 3) {
                      return Container(
                        margin: EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: _currentStep != 0
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.end,
                          children: [
                            if (_currentStep != 0)
                              GestureDetector(
                                onTap: details.onStepCancel,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_back_ios_new_outlined,
                                        color: ColorResources.COLOR_BLACK
                                            .withOpacity(0.6),
                                        size: 14,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "PREV",
                                        style: _subTitle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (_currentStep != 3)
                              GestureDetector(
                                onTap: details.onStepContinue,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context).primaryColor),
                                    borderRadius: BorderRadius.circular(4),
                                    color: Theme.of(context).cardColor,
                                  ),
                                  child: Row(
                                    children: [
                                      // _currentStep == 2
                                      Text(
                                        "NEXT",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        color: Theme.of(context).primaryColor,
                                        size: 14,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (_currentStep == 3)
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: details.onStepContinue,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor),
                                        borderRadius: BorderRadius.circular(4),
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      child: Row(
                                        children: [
                                          // _currentStep == 2
                                          Text(
                                            "COMPLETED",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                          ],
                        ),
                      );
                    }

                    return Container();
                  },
                  steps: [
                    Step(
                      title: SizedBox.shrink(),
                      label: new Text("Plant"),
                      content: _plantBuilder,
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 0
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: SizedBox.shrink(),
                      label: new Text("Pot"),
                      content: _productBuilder,
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 1
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: SizedBox.shrink(),
                      label: new Text("Soil"),
                      content: Text("Select Soil"),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 2
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: SizedBox.shrink(),
                      label: new Text("Completed"),
                      content: Text("Completed"),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 3
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
