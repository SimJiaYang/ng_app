import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:nurserygardenapp/data/model/cart_model.dart';
import 'package:nurserygardenapp/providers/cart_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/custom_text_style.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/screen/cart/widget/empty_cart_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartProvider cart_prov =
      Provider.of<CartProvider>(context, listen: false);

  final _scrollController = ScrollController();

  bool isCheckedAll = false;

  double totalAmount = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (cart_prov.cartItem.length < int.parse(params['limit']!)) return;
      int currentLimit = int.parse(params['limit']!);
      currentLimit += 8;
      params['limit'] = currentLimit.toString();
      _loadData(isLoadMore: true);
    }
  }

  // Param
  var params = {
    'limit': '8',
  };

  Future<void> _loadData({bool isLoadMore = false}) async {
    setState(() {
      totalAmount = 0;
      isCheckedAll = false;
    });
    await cart_prov.getCartItem(context, params, isLoadMore: isLoadMore);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void getTotalAmount() {
    setState(() {
      totalAmount = 0;
    });
    for (int i = 0; i < cart_prov.cartItem.length; i++) {
      setState(() {
        totalAmount +=
            (cart_prov.cartItem[i].price! * cart_prov.cartItem[i].quantity!);
      });
    }
  }

  void getCartList() {
    cart_prov.clearCartList();
    for (int i = 0; i < cart_prov.cartItem.length; i++) {
      setState(() {
        cart_prov.addedCartList.add(cart_prov.cartItem[i]);
        cart_prov.cartItem[i].isChecked = true;
      });
    }
  }

  void clearCartList() {
    cart_prov.addedCartList.clear();
    setState(() {
      totalAmount = 0;
    });
    for (int i = 0; i < cart_prov.cartItem.length; i++) {
      setState(() {
        cart_prov.cartItem[i].isChecked = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Cart",
          style: CustomTextStyles(context).subTitleStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 18,
              ),
        ),
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: ColorResources.COLOR_PRIMARY,
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
                                      fontWeight: FontWeight.w900,
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
                    child: Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                      return GestureDetector(
                        onTap: () async {
                          if (cartProvider.addedCartList.isEmpty) {
                            EasyLoading.showError('No item added yet',
                                dismissOnTap: true,
                                duration: Duration(milliseconds: 500));
                            return;
                          }
                          ;
                          Navigator.pushNamed(context,
                                  Routes.getOrderConfirmationRoute("cart"))
                              .then((value) {
                            _loadData();
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: cart_prov.addedCartList.isEmpty
                                ? ColorResources.COLOR_PRIMARY.withOpacity(0.7)
                                : ColorResources.COLOR_PRIMARY,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Checkout',
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
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Consumer<CartProvider>(builder: (context, cartProvider, child) {
          return cartProvider.cartItem.isEmpty && cartProvider.isLoading
              ? ListView.builder(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return EmptyCartItem();
                  })
              : cartProvider.cartItem.isEmpty && !cartProvider.isLoading
                  ? Center(
                      child: Text(
                        "No Cart Add Yet",
                        style: TextStyle(
                            color: Colors.grey.withOpacity(0.7), fontSize: 18),
                      ),
                    )
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      controller: _scrollController,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.white,
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Checkbox(
                                  activeColor: ColorResources.COLOR_PRIMARY,
                                  checkColor: ColorResources.COLOR_WHITE,
                                  value: isCheckedAll,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isCheckedAll = value!;
                                      if (value == true) {
                                        setState(() {
                                          getTotalAmount();
                                        });
                                        getCartList();
                                      } else {
                                        clearCartList();
                                      }
                                    });
                                  },
                                ),
                                Text(
                                  "Select All",
                                  style: theme.titleMedium,
                                ),
                              ],
                            ),
                          ),
                          ListView.builder(
                            padding: (cartProvider
                                            .noMoreDataMessage.isNotEmpty &&
                                        !cartProvider.isLoading ||
                                    (cartProvider.noMoreDataMessage.isEmpty &&
                                        cartProvider.cartItem.length < 8))
                                ? EdgeInsets.fromLTRB(10, 0, 10, 10)
                                : EdgeInsets.only(
                                    bottom: 235, left: 10, right: 10, top: 0),
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: cartProvider.cartItem.length +
                                (cartProvider.isLoading &&
                                        cartProvider.cartItem.length >= 8
                                    ? 1
                                    : 0),
                            itemBuilder: (BuildContext context, int index) {
                              if (index >= cartProvider.cartItem.length &&
                                  cartProvider.noMoreDataMessage.isEmpty) {
                                return EmptyCartItem();
                              } else {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (cartProvider
                                                  .cartItem[index].plantId !=
                                              null)
                                            Navigator.pushNamed(
                                                context,
                                                Routes.getPlantDetailRoute(
                                                    cartProvider.cartItem[index]
                                                        .plantId!
                                                        .toString(),
                                                    "false",
                                                    "true"));
                                          if (cartProvider
                                                  .cartItem[index].productId !=
                                              null)
                                            Navigator.pushNamed(
                                                context,
                                                Routes.getProductDetailRoute(
                                                    cartProvider.cartItem[index]
                                                        .productId!
                                                        .toString(),
                                                    'false',
                                                    'true'));
                                        },
                                        child: Slidable(
                                          key: ValueKey(
                                              cartProvider.cartItem[index].id),
                                          // The end action pane is the one at the right or the bottom side.
                                          endActionPane: ActionPane(
                                            motion: ScrollMotion(),
                                            children: [
                                              SlidableAction(
                                                onPressed: (ctx) async {
                                                  bool isSucess =
                                                      await cartProvider
                                                          .deleteCart(
                                                              context,
                                                              cartProvider
                                                                  .cartItem[
                                                                      index]
                                                                  .id!
                                                                  .toString());
                                                  if (isSucess) {
                                                    cartProvider.cartItem
                                                        .removeAt(index);
                                                  }
                                                },
                                                backgroundColor:
                                                    Color(0xFFFE4A49),
                                                foregroundColor: Colors.white,
                                                icon: Icons.delete,
                                              ),
                                              SlidableAction(
                                                onPressed: (ctx) {},
                                                backgroundColor:
                                                    Color(0xFF21B7CA),
                                                foregroundColor: Colors.white,
                                                icon: Icons.share,
                                              ),
                                            ],
                                          ),
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
                                                height: 150,
                                                width: double.infinity,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  // mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Checkbox(
                                                      activeColor:
                                                          ColorResources
                                                              .COLOR_PRIMARY,
                                                      checkColor: ColorResources
                                                          .COLOR_WHITE,
                                                      value: cartProvider
                                                          .cartItem[index]
                                                          .isChecked,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          cartProvider
                                                              .cartItem[index]
                                                              .isChecked = value!;
                                                          if (value == true) {
                                                            setState(() {
                                                              totalAmount += (cartProvider
                                                                      .cartItem[
                                                                          index]
                                                                      .price! *
                                                                  cartProvider
                                                                      .cartItem[
                                                                          index]
                                                                      .quantity!);
                                                            });
                                                            cartProvider
                                                                .addedCartList
                                                                .add(cartProvider
                                                                        .cartItem[
                                                                    index]);
                                                          } else {
                                                            setState(() {
                                                              isCheckedAll =
                                                                  false;
                                                              totalAmount -= (cartProvider
                                                                      .cartItem[
                                                                          index]
                                                                      .price! *
                                                                  cartProvider
                                                                      .cartItem[
                                                                          index]
                                                                      .quantity!);
                                                            });
                                                            cartProvider
                                                                .addedCartList
                                                                .removeWhere((element) =>
                                                                    element
                                                                        .id ==
                                                                    cartProvider
                                                                        .cartItem[
                                                                            index]
                                                                        .id);
                                                          }
                                                        });
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    if (cartProvider
                                                            .cartItem[index]
                                                            .plantId !=
                                                        null)
                                                      Container(
                                                        height: 100,
                                                        width: 100,
                                                        child:
                                                            CachedNetworkImage(
                                                          filterQuality:
                                                              FilterQuality
                                                                  .high,
                                                          imageUrl:
                                                              "${cartProvider.getCartPlantList.where((element) {
                                                                    return element
                                                                            .id ==
                                                                        cartProvider
                                                                            .cartItem[index]
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
                                                            .cartItem[index]
                                                            .productId !=
                                                        null)
                                                      Container(
                                                        height: 100,
                                                        width: 100,
                                                        child:
                                                            CachedNetworkImage(
                                                          filterQuality:
                                                              FilterQuality
                                                                  .high,
                                                          imageUrl:
                                                              "${"${cartProvider.getCartProductList.where((element) {
                                                                    return element
                                                                            .id ==
                                                                        cartProvider
                                                                            .cartItem[index]
                                                                            .productId;
                                                                  }).first.imageURL!}"}",
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
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        if (cartProvider
                                                                .cartItem[index]
                                                                .plantId !=
                                                            null)
                                                          Text(
                                                            "${cartProvider.getCartPlantList.where((element) {
                                                                              return element.id == cartProvider.cartItem[index].plantId;
                                                                            }).first.name}"
                                                                        .length >
                                                                    10
                                                                ? "${cartProvider.getCartPlantList.where((element) {
                                                                      return element
                                                                              .id ==
                                                                          cartProvider
                                                                              .cartItem[index]
                                                                              .plantId;
                                                                    }).first.name!.substring(0, 10)}"
                                                                : "${cartProvider.getCartPlantList.where((element) {
                                                                      return element
                                                                              .id ==
                                                                          cartProvider
                                                                              .cartItem[index]
                                                                              .plantId;
                                                                    }).first.name}",
                                                            style: TextStyle(
                                                                fontSize: 16),
                                                          ),
                                                        if (cartProvider
                                                                .cartItem[index]
                                                                .productId !=
                                                            null)
                                                          Text(
                                                            "${cartProvider.getCartProductList.where((element) {
                                                                              return element.id == cartProvider.cartItem[index].productId;
                                                                            }).first.name}"
                                                                        .length >
                                                                    10
                                                                ? "${cartProvider.getCartProductList.where((element) {
                                                                      return element
                                                                              .id ==
                                                                          cartProvider
                                                                              .cartItem[index]
                                                                              .productId;
                                                                    }).first.name!.substring(0, 10)}"
                                                                : "${cartProvider.getCartProductList.where((element) {
                                                                      return element
                                                                              .id ==
                                                                          cartProvider
                                                                              .cartItem[index]
                                                                              .productId;
                                                                    }).first.name}",
                                                            style: TextStyle(
                                                                fontSize: 16),
                                                          ),
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                        if (cartProvider
                                                                .cartItem[index]
                                                                .plantId !=
                                                            null)
                                                          Text(
                                                            "RM: " +
                                                                "${cartProvider.getCartPlantList.where((element) {
                                                                      return element
                                                                              .id ==
                                                                          cartProvider
                                                                              .cartItem[index]
                                                                              .plantId;
                                                                    }).first.price!.toStringAsFixed(2)}",
                                                            style: TextStyle(
                                                                fontSize: 14),
                                                          ),
                                                        if (cartProvider
                                                                .cartItem[index]
                                                                .productId !=
                                                            null)
                                                          Text(
                                                            "RM: " +
                                                                "${cartProvider.getCartProductList.where((element) {
                                                                      return element
                                                                              .id ==
                                                                          cartProvider
                                                                              .cartItem[index]
                                                                              .productId;
                                                                    }).first.price!.toStringAsFixed(2)}",
                                                            style: TextStyle(
                                                                fontSize: 14),
                                                          ),
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                        Container(
                                                          height: 30,
                                                          child: InputQty.int(
                                                            decoration:
                                                                QtyDecorationProps(
                                                              isBordered: false,
                                                              borderShape:
                                                                  BorderShapeBtn
                                                                      .none,
                                                              btnColor:
                                                                  ColorResources
                                                                      .COLOR_PRIMARY,
                                                              width: 12,
                                                              plusBtn: Icon(
                                                                Icons
                                                                    .add_box_outlined,
                                                                size: 30,
                                                                color: ColorResources
                                                                    .COLOR_PRIMARY,
                                                              ),
                                                              minusBtn: Icon(
                                                                Icons
                                                                    .indeterminate_check_box_outlined,
                                                                size: 30,
                                                                color: ColorResources
                                                                    .COLOR_PRIMARY,
                                                              ),
                                                            ),
                                                            //Need Change
                                                            maxVal: 100000,
                                                            initVal: cartProvider
                                                                .cartItem[index]
                                                                .quantity as num,
                                                            minVal: 1,
                                                            steps: 1,
                                                            onQtyChanged:
                                                                (val) async {
                                                              Cart cart =
                                                                  new Cart(
                                                                quantity: val,
                                                                id: cartProvider
                                                                    .cartItem[
                                                                        index]
                                                                    .id,
                                                              );
                                                              await cartProvider
                                                                  .updateCart(
                                                                      context,
                                                                      cart)
                                                                  .then(
                                                                      (value) {
                                                                if (value ==
                                                                    true) {
                                                                  setState(() {
                                                                    cartProvider
                                                                        .cartItem[
                                                                            index]
                                                                        .quantity = val;
                                                                  });
                                                                } else {
                                                                  _loadData();
                                                                }
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    );
        }),
      ),
    );
  }
}
