import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:nurserygardenapp/data/model/cart_model.dart';
import 'package:nurserygardenapp/data/model/plant_model.dart';
import 'package:nurserygardenapp/providers/cart_provider.dart';
import 'package:nurserygardenapp/providers/plant_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/view/base/custom_button.dart';
import 'package:nurserygardenapp/view/base/custom_space.dart';
import 'package:provider/provider.dart';

class PlantDetailScreen extends StatefulWidget {
  final String plantID;
  final String isSearch;
  final String isCart;
  const PlantDetailScreen({
    required this.isSearch,
    required this.plantID,
    required this.isCart,
    super.key,
  });

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  late var plant_prov = Provider.of<PlantProvider>(context, listen: false);
  late var cart_prov = Provider.of<CartProvider>(context, listen: false);
  late Plant plant = Plant();
  bool isLoading = true;
  int cartQuantity = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      return getPlantInformation();
    });
  }

  getPlantInformation() {
    if (widget.isCart == "true") {
      plant = cart_prov.getCartPlantList
          .firstWhere((element) => element.id.toString() == widget.plantID);
    } else if (widget.isSearch == "true") {
      plant = plant_prov.plantListSearch
          .firstWhere((element) => element.id.toString() == widget.plantID);
    } else {
      plant = plant_prov.plantList
          .firstWhere((element) => element.id.toString() == widget.plantID);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> addToCart() async {
    Navigator.pop(context);
    EasyLoading.show(status: 'loading...');
    Cart cart = Cart();
    cart.plantId = plant.id;
    cart.quantity = cartQuantity;
    cart.price = plant.price! * cartQuantity;
    cart.dateAdded = DateTime.now();
    cart.isPurchase = "false";

    await cart_prov.addToCart(context, cart);
    EasyLoading.dismiss();
  }

  void showModalBottom(int index, BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return index == 0
            ? Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        offset: const Offset(0, 2),
                        blurRadius: 10.0),
                  ],
                ),
                height: MediaQuery.of(context).size.height * 0.5,
                width: double.infinity,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              child: CachedNetworkImage(
                                filterQuality: FilterQuality.high,
                                imageUrl: "${plant.imageURL!}",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => Padding(
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
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${plant.name}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 19,
                                        color: ColorResources.COLOR_BLACK
                                            .withOpacity(0.9)),
                                  ),
                                  Text(
                                    "Inventory: ${plant.quantity}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        color: ColorResources.COLOR_BLACK
                                            .withOpacity(0.7)),
                                  ),
                                  Expanded(child: Container()),
                                  Text(
                                    "RM ${plant.price!.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 19,
                                        color: ColorResources.COLOR_BLACK
                                            .withOpacity(0.8)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(),
                      Expanded(child: Container()),
                      Container(
                        height: 30,
                        child: Row(
                          children: [
                            Text(
                              "Enter the quantity: ",
                              style: TextStyle(fontSize: 14),
                            ),
                            InputQty.int(
                              decoration: QtyDecorationProps(
                                isBordered: false,
                                borderShape: BorderShapeBtn.none,
                                btnColor: ColorResources.COLOR_PRIMARY,
                                width: 12,
                                plusBtn: Icon(
                                  Icons.add_box_outlined,
                                  size: 25,
                                  color: ColorResources.COLOR_PRIMARY,
                                ),
                                minusBtn: Icon(
                                  Icons.indeterminate_check_box_outlined,
                                  size: 25,
                                  color: ColorResources.COLOR_PRIMARY,
                                ),
                              ),
                              //Need Change
                              maxVal: plant.quantity!,
                              initVal: cartQuantity,
                              minVal: 1,
                              steps: 1,
                              onQtyChanged: (val) {
                                setState(() {
                                  cartQuantity = val;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: Container()),
                      CustomButton(
                        btnTxt: 'Add to cart',
                        onTap: () async {
                          await addToCart();
                        },
                      )
                      // const Text('Modal BottomSheet'),
                      // ElevatedButton(
                      //   child: const Text('Close BottomSheet'),
                      //   onPressed: () => Navigator.pop(context),
                      // ),
                    ],
                  ),
                ),
              )
            : Container(
                height: MediaQuery.of(context).size.height * 0.5,
                color: Colors.grey,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('Modal BottomSheet'),
                      ElevatedButton(
                        child: const Text('Close BottomSheet'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.white, // <-- SEE HERE
          ),
          backgroundColor: ColorResources.COLOR_PRIMARY,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.favorite_border_outlined,
                color: Colors.white,
              ),
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
            height: 60,
            padding: EdgeInsets.all(0),
            child: Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showModalBottom(0, context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorResources.COLOR_PRIMARY,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.add_shopping_cart_outlined,
                                color: Colors.white,
                              ),
                              Text(
                                'Add to cart',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Container(
                    //   color: Colors.white,
                    //   width: 2,
                    // ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showModalBottom(1, context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: ColorResources.COLOR_WHITE,
                              border: Border.all(
                                color: ColorResources.COLOR_PRIMARY,
                                width: 1,
                              )),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Buy now",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ColorResources.COLOR_PRIMARY),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ]),
            )),
        body: SafeArea(
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          color: ColorResources.COLOR_WHITE,
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return ImageEnlargeWidget(
                                  tag: "plant_${plant.id}",
                                  url: "${plant.imageURL!}",
                                );
                              }));
                            },
                            child: Hero(
                              tag: "plant_${plant.id}",
                              child: CachedNetworkImage(
                                filterQuality: FilterQuality.high,
                                height: 300,
                                fit: BoxFit.fitHeight,
                                imageUrl: "${plant.imageURL!}",
                                placeholder: (context, url) => Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Center(
                                      child: CircularProgressIndicator(
                                    color: ColorResources.COLOR_GRAY,
                                  )),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          color: ColorResources.COLOR_WHITE,
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${plant.name}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20,
                                      )),
                              VerticalSpacing(
                                height: 10,
                              ),
                              Text("RM ${plant.price!.toStringAsFixed(2)}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                          color: ColorResources.COLOR_PRIMARY)),
                            ],
                          ),
                        ),
                        VerticalSpacing(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          color: ColorResources.COLOR_WHITE,
                          padding: EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Category:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: ColorResources.COLOR_BLACK
                                              .withOpacity(0.8))),
                              HorizontalSpacing(
                                width: 3,
                              ),
                              Text("${plant.categoryName}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          color: ColorResources.COLOR_BLACK
                                              .withOpacity(0.8))),
                              Expanded(child: Container()),
                              Text("Inventory:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: ColorResources.COLOR_BLACK
                                              .withOpacity(0.8))),
                              HorizontalSpacing(
                                width: 3,
                              ),
                              Text("${plant.quantity}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          color: ColorResources.COLOR_BLACK
                                              .withOpacity(0.8)))
                            ],
                          ),
                        ),
                        VerticalSpacing(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          color: ColorResources.COLOR_WHITE,
                          padding: EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Plant Origin:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: ColorResources.COLOR_BLACK
                                              .withOpacity(0.8))),
                              HorizontalSpacing(
                                width: 3,
                              ),
                              Text(
                                  "${plant.origin!.length > 10 ? plant.origin!.substring(0, 10) + ".." : plant.origin}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          color: ColorResources.COLOR_BLACK
                                              .withOpacity(0.8))),
                              Expanded(child: Container()),
                              Text("Mature Height:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: ColorResources.COLOR_BLACK
                                              .withOpacity(0.8))),
                              HorizontalSpacing(
                                width: 3,
                              ),
                              Text("${plant.matureHeight}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          color: ColorResources.COLOR_BLACK
                                              .withOpacity(0.8)))
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          color: ColorResources.COLOR_WHITE,
                          padding: EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Sunlight Need:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: ColorResources.COLOR_BLACK
                                              .withOpacity(0.8))),
                              HorizontalSpacing(
                                width: 3,
                              ),
                              Text("${plant.sunlightNeed}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          color: ColorResources.COLOR_BLACK
                                              .withOpacity(0.8))),
                              Expanded(child: Container()),
                              Text("Water Need:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: ColorResources.COLOR_BLACK
                                              .withOpacity(0.8))),
                              HorizontalSpacing(
                                width: 3,
                              ),
                              Text("${plant.waterNeed}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          color: ColorResources.COLOR_BLACK
                                              .withOpacity(0.8)))
                            ],
                          ),
                        ),
                        VerticalSpacing(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          color: ColorResources.COLOR_WHITE,
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Description",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: ColorResources.COLOR_BLACK
                                              .withOpacity(0.8))),
                              VerticalSpacing(
                                height: 10,
                              ),
                              Text("${plant.description}",
                                  textAlign: TextAlign.justify,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          color: ColorResources.COLOR_BLACK
                                              .withOpacity(0.8))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ));
  }
}

class ImageEnlargeWidget extends StatefulWidget {
  final String tag;
  final String url;

  ImageEnlargeWidget({required this.tag, required this.url});

  @override
  _ImageEnlargeWidgetState createState() => _ImageEnlargeWidgetState();
}

class _ImageEnlargeWidgetState extends State<ImageEnlargeWidget> {
  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          child: Center(
            child: Hero(
              tag: widget.tag,
              child: CachedNetworkImage(
                imageUrl: widget.url,
                placeholder: (context, url) => Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Center(
                      child: CircularProgressIndicator(
                    color: ColorResources.COLOR_GRAY,
                  )),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
