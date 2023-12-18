import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nurserygardenapp/providers/cart_provider.dart';
import 'package:nurserygardenapp/providers/address_provider.dart';
import 'package:nurserygardenapp/providers/order_provider.dart';
import 'package:nurserygardenapp/providers/plant_provider.dart';
import 'package:nurserygardenapp/providers/product_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/custom_text_style.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/base/circular_indicator.dart';
import 'package:nurserygardenapp/view/base/page_loading.dart';
import 'package:nurserygardenapp/view/screen/payment/payment_helper/payment_type.dart';
import 'package:provider/provider.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final String comeFrom;
  const OrderConfirmationScreen({
    super.key,
    this.comeFrom = "cart",
  });

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  final String cartMode = "cart";
  final String plantMode = "plant";
  final String productMode = "product";

  late CartProvider cart_prov =
      Provider.of<CartProvider>(context, listen: false);
  late OrderProvider order_prov =
      Provider.of<OrderProvider>(context, listen: false);
  late AddressProvider address_prov =
      Provider.of<AddressProvider>(context, listen: false);
  double totalAmount = 0;

  final String emptyAddress_msg =
      "Please add your address prior make the order.";

  final String error_msg = "Some error occur, please try again later.";

  String address = "";

  var params = {};

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      return _getInitalData();
    });
  }

  _getInitalData() async {
    double total = 0;
    cart_prov.addedCartList.forEach((element) {
      total += element.quantity! * element.price!;
    });
    bool result = await address_prov.getAddressList(context, params);

    setState(() {
      totalAmount = total;
      if (result) {
        if (address_prov.addressList.length > 0) {
          address = address_prov.addressList[0].address ?? '';
        } else {
          address = emptyAddress_msg;
        }
      } else {
        address = error_msg;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: ColorResources.COLOR_PRIMARY,
            leading: BackButton(
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            title: Text(
              "Checkout",
              style: CustomTextStyles(context).subTitleStyle.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: Colors.white),
            )),
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
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: ColorResources.COLOR_WHITE,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Total RM: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: ColorResources.COLOR_BLACK),
                                ),
                                Text(totalAmount.toStringAsFixed(2),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: ColorResources.COLOR_PRIMARY))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Consumer2<OrderProvider, CartProvider>(builder:
                          (context, orderProvider, cartProvider, child) {
                        return GestureDetector(
                          onTap: () async {
                            if (address == emptyAddress_msg) {
                              EasyLoading.showError('Please add your address',
                                  dismissOnTap: true,
                                  duration: Duration(milliseconds: 500));
                              return;
                            }
                            if (address == error_msg) {
                              EasyLoading.showError(
                                  'Some error occur, please try again later',
                                  dismissOnTap: true,
                                  duration: Duration(milliseconds: 500));
                              return;
                            }
                            if (orderProvider.isLoading) return;
                            if (widget.comeFrom == cartMode) {
                              if (orderProvider.isLoading) return;
                              await orderProvider
                                  .addOrder(
                                      cart_prov.addedCartList, address, context)
                                  .then((value) {
                                if (value == true) {
                                  Navigator.pushReplacementNamed(
                                      context,
                                      Routes.getPaymentRoute(
                                          (PaymentType.card).toString(),
                                          orderProvider.orderIdCreated));
                                }
                              });
                            }
                            if (widget.comeFrom == plantMode) {
                              if (cartProvider.isLoading ||
                                  orderProvider.isLoading) return;

                              await cartProvider
                                  .addToCart(
                                      context, cartProvider.addedCartList.first,
                                      ismsg: false, isCart: false)
                                  .then((value) async {
                                if (value == true) {
                                  await orderProvider
                                      .addOrder(cartProvider.returnAddCart,
                                          address, context)
                                      .then((value) {
                                    if (value == true) {
                                      Navigator.pushReplacementNamed(
                                          context,
                                          Routes.getPaymentRoute(
                                              (PaymentType.card).toString(),
                                              orderProvider.orderIdCreated));
                                    }
                                  });
                                }
                              });
                            }
                            if (widget.comeFrom == productMode) {
                              await cartProvider
                                  .addToCart(
                                      context, cartProvider.addedCartList.first,
                                      ismsg: false, isCart: false)
                                  .then((value) async {
                                if (value == true) {
                                  await orderProvider
                                      .addOrder(cartProvider.returnAddCart,
                                          address, context)
                                      .then((value) {
                                    if (value == true) {
                                      Navigator.pushReplacementNamed(
                                          context,
                                          Routes.getPaymentRoute(
                                              (PaymentType.card).toString(),
                                              orderProvider.orderIdCreated));
                                    }
                                  });
                                }
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: address == emptyAddress_msg ||
                                      address == error_msg
                                  ? ColorResources.COLOR_PRIMARY
                                      .withOpacity(0.7)
                                  : ColorResources.COLOR_PRIMARY,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                orderProvider.isLoading
                                    ? CircularProgress()
                                    : Text(
                                        'Place Order',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      )
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ]),
            )),
        body: Consumer4<CartProvider, AddressProvider, PlantProvider,
                ProductProvider>(
            builder: (context, cartProvider, addressProvider, plantProvider,
                productProvider, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            child: addressProvider.isLoading
                ? LoadingThreeCircle()
                : SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                    context, Routes.getOrderAddressRoute(),
                                    arguments: {'orderID': "0", "address": ""})
                                .then((value) {
                              if (value == null) return;
                              setState(() {
                                address = value as String;
                              });
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            color: Colors.white,
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Delivery Address",
                                  style: CustomTextStyles(context)
                                      .titleStyle
                                      .copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  address,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          child: Divider(
                            color: ColorResources.COLOR_GREY.withOpacity(0.1),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: cartProvider.addedCartList.length < 2
                              ? MediaQuery.of(context).size.height / 5
                              : cartProvider.addedCartList.length == 3
                                  ? MediaQuery.of(context).size.height / 2.8
                                  : MediaQuery.of(context).size.height / 2.5,
                          child: ListView.builder(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                              shrinkWrap: true,
                              itemCount: cartProvider.addedCartList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    offset: const Offset(0, 2),
                                                    blurRadius: 10.0),
                                              ],
                                            ),
                                            child: Container(
                                                padding: EdgeInsets.all(5),
                                                height: 120,
                                                width: double.infinity,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    if (cartProvider
                                                            .addedCartList[
                                                                index]
                                                            .plantId !=
                                                        null)
                                                      Container(
                                                        height: 80,
                                                        width: 80,
                                                        child:
                                                            CachedNetworkImage(
                                                          filterQuality:
                                                              FilterQuality
                                                                  .high,
                                                          imageUrl: widget
                                                                      .comeFrom ==
                                                                  cartMode
                                                              ? "${cartProvider.getCartPlantList.where((element) {
                                                                    return element
                                                                            .id ==
                                                                        cartProvider
                                                                            .addedCartList[index]
                                                                            .plantId;
                                                                  }).first.imageURL!}"
                                                              : "${plantProvider.plantList.where((element) {
                                                                    return element
                                                                            .id ==
                                                                        cartProvider
                                                                            .addedCartList[index]
                                                                            .plantId;
                                                                  }).first.imageURL!}",
                                                          memCacheHeight: 200,
                                                          memCacheWidth: 200,
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .fitHeight,
                                                              ),
                                                            ),
                                                          ),
                                                          placeholder:
                                                              (context, url) =>
                                                                  Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(1.0),
                                                            child: Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                              color:
                                                                  ColorResources
                                                                      .COLOR_GRAY,
                                                            )),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.error),
                                                        ),
                                                      ),
                                                    if (cartProvider
                                                            .addedCartList[
                                                                index]
                                                            .productId !=
                                                        null)
                                                      Container(
                                                        height: 80,
                                                        width: 80,
                                                        child:
                                                            CachedNetworkImage(
                                                          filterQuality:
                                                              FilterQuality
                                                                  .high,
                                                          imageUrl: widget
                                                                      .comeFrom ==
                                                                  cartMode
                                                              ? "${cartProvider.getCartProductList.where((element) {
                                                                    return element
                                                                            .id ==
                                                                        cartProvider
                                                                            .addedCartList[index]
                                                                            .productId;
                                                                  }).first.imageURL!}"
                                                              : "${productProvider.productList.where((element) {
                                                                    return element
                                                                            .id ==
                                                                        cartProvider
                                                                            .addedCartList[index]
                                                                            .productId;
                                                                  }).first.imageURL!}",
                                                          memCacheHeight: 200,
                                                          memCacheWidth: 200,
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .fitHeight,
                                                              ),
                                                            ),
                                                          ),
                                                          placeholder:
                                                              (context, url) =>
                                                                  Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(1.0),
                                                            child: Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                              color:
                                                                  ColorResources
                                                                      .COLOR_GRAY,
                                                            )),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.error),
                                                        ),
                                                      ),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              if (cartProvider
                                                                      .addedCartList[
                                                                          index]
                                                                      .plantId !=
                                                                  null)
                                                                widget.comeFrom ==
                                                                        cartMode
                                                                    ? Flexible(
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              100,
                                                                          child:
                                                                              Text(
                                                                            "${cartProvider.getCartPlantList.where((element) {
                                                                                  return element.id == cartProvider.addedCartList[index].plantId;
                                                                                }).first.name}",
                                                                            style:
                                                                                TextStyle(fontSize: 16),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Flexible(
                                                                        child:
                                                                            Text(
                                                                          "${plantProvider.plantList.where((element) {
                                                                                return element.id == cartProvider.addedCartList[index].plantId;
                                                                              }).first.name}",
                                                                          style:
                                                                              TextStyle(fontSize: 16),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                              if (cartProvider
                                                                      .addedCartList[
                                                                          index]
                                                                      .productId !=
                                                                  null)
                                                                widget.comeFrom ==
                                                                        cartMode
                                                                    ? Flexible(
                                                                        child:
                                                                            Text(
                                                                          "${cartProvider.getCartProductList.where((element) {
                                                                                return element.id == cartProvider.addedCartList[index].productId;
                                                                              }).first.name}",
                                                                          style:
                                                                              TextStyle(fontSize: 16),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      )
                                                                    : Flexible(
                                                                        child:
                                                                            Text(
                                                                          "${productProvider.productList.where((element) {
                                                                                return element.id == cartProvider.addedCartList[index].productId;
                                                                              }).first.name}",
                                                                          style:
                                                                              TextStyle(fontSize: 16),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                              SizedBox(
                                                                height: 4,
                                                              ),
                                                              Text(
                                                                  "Quantity: ${cartProvider.addedCartList[index].quantity}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14)),
                                                              SizedBox(
                                                                height: 4,
                                                              ),
                                                            ],
                                                          ),
                                                          Expanded(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                    "RM" +
                                                                        "${(cartProvider.addedCartList[index].quantity! * cartProvider.addedCartList[index].price!).toStringAsFixed(2)}",
                                                                    style: TextStyle(
                                                                        color: ColorResources
                                                                            .COLOR_PRIMARY,
                                                                        fontSize:
                                                                            16))
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          ),
                                        ),
                                      ),
                                    ]);
                              }),
                        ),
                        Container(
                          width: double.infinity,
                          color: Colors.white,
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Order Total",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "RM" + "${totalAmount.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: ColorResources.COLOR_PRIMARY),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          color: Colors.white,
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.monetization_on),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text(
                                      "Payment Options",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "Debit/Credit card",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: ColorResources.COLOR_PRIMARY),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        }));
  }
}
