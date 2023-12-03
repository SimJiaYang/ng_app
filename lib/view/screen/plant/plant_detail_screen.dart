import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:nurserygardenapp/data/model/cart_model.dart';
import 'package:nurserygardenapp/data/model/plant_model.dart';
import 'package:nurserygardenapp/providers/cart_provider.dart';
import 'package:nurserygardenapp/providers/plant_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/dimensions.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/base/custom_button.dart';
import 'package:nurserygardenapp/view/base/custom_space.dart';
import 'package:nurserygardenapp/view/base/image_enlarge_widget.dart';
import 'package:nurserygardenapp/view/base/page_loading.dart';
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
    cart.isCart = true;
    try {
      await cart_prov.addToCart(context, cart);
    } on Exception catch (e) {
      print(e.toString());
      EasyLoading.dismiss();
    }
    EasyLoading.dismiss();
  }

  void checkout() {
    Navigator.pop(context);
    Cart cart = Cart();
    cart.plantId = plant.id;
    cart.quantity = cartQuantity;
    cart.price = plant.price;
    cart.dateAdded = DateTime.now();
    cart.isPurchase = "false";
    cart.isCart = false;
    cart_prov.addCartList(cart);
    Navigator.pushNamed(context, Routes.getOrderConfirmationRoute("plant"))
        .then((value) {
      if (value == true) {
        cart_prov.clearCartList();
        getPlantInformation();
      }
      ;
    });
  }

  void showModalBottom(int index, BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
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
          height: MediaQuery.of(context).size.height * 0.4,
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
                          imageBuilder: (context, imageProvider) => Container(
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
                Spacer(),
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
                  btnTxt: index == 0 ? 'Add to cart' : 'Checkout',
                  onTap: () async {
                    if (index == 0) await addToCart();
                    if (index == 1) checkout();
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    TextStyle _title = theme.headlineMedium!.copyWith(
      fontSize: Dimensions.FONT_SIZE_DEFAULT,
      color: ColorResources.COLOR_BLACK.withOpacity(0.8),
    );
    TextStyle _subTitle = theme.headlineMedium!.copyWith(
      fontSize: Dimensions.FONT_SIZE_DEFAULT,
      color: ColorResources.COLOR_BLACK.withOpacity(0.6),
    );

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
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey,
                      offset: const Offset(0, 2),
                      blurRadius: 10.0),
                ],
              ),
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
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
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
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Buy now",
                                style: TextStyle(
                                    fontSize: 14,
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
              ? LoadingThreeCircle()
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
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
                                  style: _title.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_LARGE)),
                              VerticalSpacing(
                                height: 10,
                              ),
                              Text("RM ${plant.price!.toStringAsFixed(2)}",
                                  style: _title.copyWith(
                                      fontSize:
                                          Dimensions.FONT_SIZE_EXTRA_LARGE,
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
                              Text("Category:", style: _title),
                              HorizontalSpacing(
                                width: 3,
                              ),
                              Text("${plant.categoryName}", style: _subTitle),
                              Expanded(child: Container()),
                              Text("Inventory:", style: _title),
                              HorizontalSpacing(
                                width: 3,
                              ),
                              Text("${plant.quantity}", style: _subTitle)
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
                              Text("Plant Origin:", style: _title),
                              HorizontalSpacing(
                                width: 3,
                              ),
                              Text(
                                  "${plant.origin!.length > 10 ? plant.origin!.substring(0, 10) + ".." : plant.origin}",
                                  overflow: TextOverflow.ellipsis,
                                  style: _subTitle),
                              Expanded(child: Container()),
                              Text("Mature Height:", style: _title),
                              HorizontalSpacing(
                                width: 3,
                              ),
                              Text("${plant.matureHeight} m", style: _subTitle)
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
                              Text("Sunlight Need:", style: _title),
                              HorizontalSpacing(
                                width: 3,
                              ),
                              Text("${plant.sunlightNeed}", style: _subTitle),
                              Expanded(child: Container()),
                              Text("Water Need:", style: _title),
                              HorizontalSpacing(
                                width: 3,
                              ),
                              Text("${plant.waterNeed}", style: _subTitle)
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
                              Text("Description", style: _title),
                              VerticalSpacing(
                                height: 10,
                              ),
                              Text("${plant.description}",
                                  textAlign: TextAlign.justify,
                                  style: _subTitle),
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
