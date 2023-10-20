import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:nurserygardenapp/data/model/cart_model.dart';
import 'package:nurserygardenapp/data/model/product_model.dart';
import 'package:nurserygardenapp/providers/cart_provider.dart';
import 'package:nurserygardenapp/providers/product_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/view/base/custom_button.dart';
import 'package:nurserygardenapp/view/base/custom_space.dart';
import 'package:nurserygardenapp/view/base/image_enlarge_widget.dart';
import 'package:nurserygardenapp/view/screen/plant/plant_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productID;
  final String isCart;
  final String isSearch;
  const ProductDetailScreen({
    required this.productID,
    required this.isCart,
    required this.isSearch,
    super.key,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late var product_prov = Provider.of<ProductProvider>(context, listen: false);
  late var cart_prov = Provider.of<CartProvider>(context, listen: false);
  late Product product = Product();
  bool isLoading = true;
  int cartQuantity = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      return getProductInformation();
    });
  }

  getProductInformation() {
    if (widget.isCart == "true") {
      product = cart_prov.getCartProductList
          .firstWhere((element) => element.id.toString() == widget.productID);
    } else if (widget.isSearch == "true") {
      product = product_prov.productListSearch
          .firstWhere((element) => element.id.toString() == widget.productID);
    } else {
      product = product_prov.productList
          .firstWhere((element) => element.id.toString() == widget.productID);
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> addToCart() async {
    Navigator.pop(context);
    EasyLoading.show(status: 'loading...');
    Cart cart = Cart();
    cart.productId = product.id;
    cart.quantity = cartQuantity;
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
                                imageUrl: "${product.imageURL!}",
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
                                    "${product.name}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 19,
                                        color: ColorResources.COLOR_BLACK
                                            .withOpacity(0.9)),
                                  ),
                                  Text(
                                    "Inventory: ${product.quantity}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        color: ColorResources.COLOR_BLACK
                                            .withOpacity(0.7)),
                                  ),
                                  Expanded(child: Container()),
                                  Text(
                                    "RM ${product.price!.toStringAsFixed(2)}",
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
                              maxVal: product.quantity!,
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
          child: Center(
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
                                    tag: "product_${product.id}",
                                    url: "${product.imageURL!}",
                                  );
                                }));
                              },
                              child: Hero(
                                tag: "product_${product.id}",
                                child: CachedNetworkImage(
                                  height: 300,
                                  fit: BoxFit.fitHeight,
                                  imageUrl: "${product.imageURL!}",
                                  filterQuality: FilterQuality.high,
                                  memCacheHeight: 200,
                                  memCacheWidth: 200,
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
                                Text("${product.name}",
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
                                Text("RM ${product.price}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18,
                                            color:
                                                ColorResources.COLOR_PRIMARY)),
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
                                Text("${product.categoryName}",
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
                                Text("${product.quantity}",
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
                                            fontSize: 13,
                                            color: ColorResources.COLOR_BLACK
                                                .withOpacity(0.8))),
                                VerticalSpacing(
                                  height: 10,
                                ),
                                Text("${product.description}",
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
          ),
        ));
  }
}
