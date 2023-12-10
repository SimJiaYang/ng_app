import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nurserygardenapp/data/model/cart_model.dart';
import 'package:nurserygardenapp/providers/customize_provider.dart';
import 'package:nurserygardenapp/util/app_constants.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/dimensions.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/screen/customization/widget/empty_item.dart';
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
  String plantID = '0';
  String productID = '0';
  String soilID = '0';

  // O3DController threed_controller = O3DController();

  var plant_params = {
    'limit': '8',
    'category': AppConstants.DESERT_ROSE,
    'status': AppConstants.CUSTOM_STATUS
  };

  var product_params = {
    'limit': '8',
    'category': AppConstants.POT,
    'status': AppConstants.CUSTOM_STATUS
  };

  var soil_params = {
    'limit': '8',
    'category': AppConstants.SOIL,
    'status': AppConstants.CUSTOM_STATUS
  };

  Future<void> _loadPlant({bool isLoadMore = false}) async {
    await custom_prov
        .listOfPlant(context, plant_params, isLoadMore: isLoadMore)
        .then((value) {
      if (custom_prov.plantList.isNotEmpty) {
        setState(() {
          plantID = custom_prov.plantList
              .firstWhere((element) => element.id == int.parse(plantID),
                  orElse: () => custom_prov.plantList.first)
              .id
              .toString();
        });
      }
    });
  }

  Future<void> _loadProduct({bool isLoadMore = false}) async {
    await custom_prov
        .listOfProduct(context, product_params, isLoadMore: isLoadMore)
        .then((value) {
      if (custom_prov.productList.isNotEmpty) {
        setState(() {
          productID = custom_prov.productList
              .firstWhere((element) => element.id == int.parse(productID),
                  orElse: () => custom_prov.productList.first)
              .id
              .toString();
        });
      }
    });
  }

  Future<void> _loadSoil({bool isLoadMore = false}) async {
    await custom_prov
        .listOfSoil(context, soil_params, isLoadMore: isLoadMore)
        .then((value) {
      if (custom_prov.soilList.isNotEmpty) {
        setState(() {
          soilID = custom_prov.soilList
              .firstWhere((element) => element.id == int.parse(soilID),
                  orElse: () => custom_prov.soilList.first)
              .id
              .toString();
        });
      }
    });
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

  void _soilScroll() {
    if (_soilController.position.pixels ==
        _soilController.position.maxScrollExtent) {
      if (custom_prov.soilList.length < int.parse(soil_params['limit']!))
        return;
      int currentLimit = int.parse(soil_params['limit']!);
      currentLimit += 8;
      soil_params['limit'] = currentLimit.toString();
      _loadSoil(isLoadMore: true);
    }
  }

  @override
  void initState() {
    super.initState();
    _plantController.addListener(_plantScroll);
    _productController.addListener(_productScroll);
    _soilController.addListener(_soilScroll);
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      custom_prov.resetSelectedItem();
      _loadPlant();
      _loadProduct();
      _loadSoil();
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
    _currentStep < 2 ? setState(() => _currentStep += 1) : _handleSubmit();
  }

  void cancel() {
    FocusScope.of(context).unfocus();
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  _handleSubmit() async {
    if (plantID == '0' || productID == '0' || soilID == '0') {
      EasyLoading.showToast('Please select all options');
      return;
    }
    List<Cart> _selectedItem = [];
    _selectedItem.add(Cart(
      plantId: int.parse(plantID),
      quantity: 1,
      price: custom_prov.plantList
          .firstWhere((element) => element.id == int.parse(plantID))
          .price,
    ));
    _selectedItem.add(Cart(
      productId: int.parse(productID),
      quantity: 1,
      price: custom_prov.productList
          .firstWhere((element) => element.id == int.parse(productID))
          .price,
    ));
    _selectedItem.add(Cart(
      productId: int.parse(soilID),
      quantity: 1,
      price: custom_prov.soilList
          .firstWhere((element) => element.id == int.parse(soilID))
          .price,
    ));
    custom_prov.addSelectedItem(_selectedItem);
    await custom_prov.getStyle(context).then((value) {
      if (value == true) {
        Navigator.pushNamed(context, Routes.getCustomizeStyleRoute());
      }
    });
  }

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
      color: const Color.fromRGBO(45, 45, 45, 1).withOpacity(0.6),
    );

    Widget _loadingView = Container(
      height: size.height,
      width: size.width,
      child: ListView.builder(
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return EmptyItem();
        },
      ),
    );

    Widget _plantBuilder =
        Consumer<CustomizeProvider>(builder: (context, customProvider, child) {
      return customProvider.isLoading && customProvider.plantList.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: size.width * 0.3,
                  height: 15,
                  color: Colors.grey[400],
                ),
                _loadingView,
              ],
            )
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
                      height: 220,
                      // height: size.height * 0.5,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: (customProvider.plantNoMoreData.isNotEmpty &&
                                      !customProvider.isLoading ||
                                  (customProvider.plantNoMoreData.isEmpty &&
                                      customProvider.plantList.length < 8))
                              ? EdgeInsets.fromLTRB(0, 0, 10, 0)
                              : EdgeInsets.fromLTRB(0, 0, 150, 0),
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
                              return _loadingView;
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
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            plantID = customProvider
                                                .plantList[index].id
                                                .toString();
                                          });
                                        },
                                        child: Container(
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
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child: Container(
                                                width: double.infinity,
                                                height: 20,
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      customProvider.plantList[index].id
                                                  .toString() ==
                                              plantID
                                          ? Icon(
                                              Icons.check,
                                              size: 25.0,
                                              weight: 50.0,
                                              color:
                                                  ColorResources.COLOR_PRIMARY,
                                            )
                                          : Container(
                                              height: 25,
                                            )
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
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: size.width * 0.3,
                  height: 15,
                  color: Colors.grey[400],
                ),
                _loadingView,
              ],
            )
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
                      height: 220,
                      // height: size.height * 0.5,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: (customProvider
                                          .productNoMoreData.isNotEmpty &&
                                      !customProvider.isLoading ||
                                  (customProvider.productNoMoreData.isEmpty &&
                                      customProvider.productList.length < 8))
                              ? EdgeInsets.fromLTRB(0, 0, 10, 0)
                              : EdgeInsets.fromLTRB(0, 0, 150, 0),
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
                              return _loadingView;
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
                                      GestureDetector(
                                        onTap: () => setState(() {
                                          productID = customProvider
                                              .productList[index].id
                                              .toString();
                                        }),
                                        child: Container(
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
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                Padding(
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child: Container(
                                                width: double.infinity,
                                                height: 20,
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      customProvider.productList[index].id
                                                  .toString() ==
                                              productID
                                          ? Icon(
                                              Icons.check,
                                              size: 25,
                                              color:
                                                  ColorResources.COLOR_PRIMARY,
                                            )
                                          : Container(
                                              height: 25,
                                            )
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

    Widget _soilBuilder =
        Consumer<CustomizeProvider>(builder: (context, customProvider, child) {
      return customProvider.isLoading && customProvider.soilList.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: size.width * 0.3,
                  height: 15,
                  color: Colors.grey[400],
                ),
                _loadingView,
              ],
            )
          : customProvider.soilList.isEmpty && !customProvider.isLoading
              ? Center(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'No Soil Data Available',
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
                      'Select Soil',
                      style: _title,
                    ),
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      height: 220,
                      // height: size.height * 0.5,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: (customProvider.soilNoMoreData.isNotEmpty &&
                                      !customProvider.isLoading ||
                                  (customProvider.soilNoMoreData.isEmpty &&
                                      customProvider.soilList.length < 8))
                              ? EdgeInsets.fromLTRB(0, 0, 10, 0)
                              : EdgeInsets.fromLTRB(0, 0, 150, 0),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          controller: _soilController,
                          itemCount: customProvider.soilList.length +
                              ((customProvider.isLoading &&
                                      customProvider.soilList.length >= 8)
                                  ? 1
                                  : customProvider.soilNoMoreData.isNotEmpty
                                      ? 1
                                      : 0),
                          itemBuilder: (context, index) {
                            if (index >= customProvider.soilList.length &&
                                customProvider.soilNoMoreData.isEmpty) {
                              return _loadingView;
                            } else if (index >=
                                    customProvider.soilList.length &&
                                customProvider.soilNoMoreData.isNotEmpty) {
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
                                      GestureDetector(
                                        onTap: () => setState(() {
                                          soilID = customProvider
                                              .soilList[index].id
                                              .toString();
                                        }),
                                        child: Container(
                                          height: 150,
                                          width: 150,
                                          child: CachedNetworkImage(
                                            filterQuality: FilterQuality.high,
                                            imageUrl:
                                                "${customProvider.soilList[index].imageURL}",
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
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child: Container(
                                                width: double.infinity,
                                                height: 20,
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      customProvider.soilList[index].id
                                                  .toString() ==
                                              soilID
                                          ? Icon(
                                              Icons.check,
                                              size: 25,
                                              color:
                                                  ColorResources.COLOR_PRIMARY,
                                            )
                                          : Container(
                                              height: 25,
                                            )
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

    // Widget _viewer = O3D(
    //   // loading: ,
    //   controller: threed_controller,
    //   src: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
    // );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorResources.COLOR_PRIMARY,
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text("Customization",
                style: _title.copyWith(
                    color: ColorResources.COLOR_WHITE, fontSize: 16)),
          ),
        ),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
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
                      if (_currentStep <= 2) {
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
                              if (_currentStep != 2)
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
                                      color: Theme.of(context).cardColor,
                                    ),
                                    child: Row(
                                      children: [
                                        // _currentStep == 2
                                        Text(
                                          "NEXT",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
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
                              if (_currentStep == 2)
                                Column(
                                  children: [
                                    Consumer<CustomizeProvider>(builder:
                                        (context, customProvider, child) {
                                      return GestureDetector(
                                        onTap: details.onStepContinue,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          child: Row(
                                            children: [
                                              if (!customProvider.isFetching)
                                                Text(
                                                  "CONTINUE",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              if (customProvider.isFetching)
                                                Container(
                                                    width: 50,
                                                    child: Center(
                                                      child:
                                                          LoadingAnimationWidget
                                                              .waveDots(
                                                                  color: Colors
                                                                      .white,
                                                                  size: 20),
                                                    )),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
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
                        content: _soilBuilder,
                        isActive: _currentStep >= 0,
                        state: _currentStep >= 2
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                      // Step(
                      //   title: SizedBox.shrink(),
                      //   label: new Text("Checkout"),
                      //   content: _viewer,
                      //   isActive: _currentStep >= 0,
                      //   state: _currentStep >= 3
                      //       ? StepState.complete
                      //       : StepState.indexed,
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
