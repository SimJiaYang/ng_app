import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:nurserygardenapp/providers/cart_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/base/circular_indicator.dart';
import 'package:nurserygardenapp/view/base/empty_data_widget.dart';
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
    await cart_prov.getCartItem(context, params, isLoadMore: isLoadMore);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Cart',
          style: TextStyle(color: ColorResources.COLOR_WHITE),
        ),
        leading: const BackButton(
          color: Colors.white, // <-- SEE HERE
        ),
        backgroundColor: ColorResources.COLOR_PRIMARY,
      ),
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
              // EmptyWidget(
              //     large: true,
              //     isLoading: cartProvider.isLoading,
              //   )
              : ListView.builder(
                  padding: (cartProvider.noMoreDataMessage.isNotEmpty &&
                          !cartProvider.isLoading)
                      ? EdgeInsets.fromLTRB(10, 0, 10, 10)
                      : EdgeInsets.only(
                          bottom: 235, left: 10, right: 10, top: 0),
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: cartProvider.getCheckBoxListTileModel.length +
                      (cartProvider.isLoading &&
                              cartProvider.getCheckBoxListTileModel.length >= 8
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
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: GestureDetector(
                              onTap: () {
                                if (cartProvider.getCheckBoxListTileModel[index]
                                        .cart.plantId !=
                                    null)
                                  Navigator.pushNamed(
                                      context,
                                      Routes.getPlantDetailRoute(
                                          cartProvider
                                              .getCheckBoxListTileModel[index]
                                              .plant!
                                              .id!
                                              .toString(),
                                          "false",
                                          "true"));
                                if (cartProvider.getCheckBoxListTileModel[index]
                                        .cart.productId !=
                                    null)
                                  Navigator.pushNamed(
                                      context,
                                      Routes.getProductDetailRoute(
                                          cartProvider
                                              .getCheckBoxListTileModel[index]
                                              .product!
                                              .id!
                                              .toString(),
                                          'true'));
                              },
                              child: Slidable(
                                key: ValueKey(cartProvider
                                    .getCheckBoxListTileModel[index].cart.id),

                                // The end action pane is the one at the right or the bottom side.
                                endActionPane: ActionPane(
                                  motion: ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (ctx) {
                                        cartProvider.deleteCart(
                                            context,
                                            cartProvider
                                                .getCheckBoxListTileModel[index]
                                                .cart
                                                .id!
                                                .toString());
                                        cartProvider.getCheckBoxListTileModel
                                            .removeAt(index);
                                      },
                                      backgroundColor: Color(0xFFFE4A49),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                    SlidableAction(
                                      onPressed: (ctx) {},
                                      backgroundColor: Color(0xFF21B7CA),
                                      foregroundColor: Colors.white,
                                      icon: Icons.share,
                                      label: 'Share',
                                    ),
                                  ],
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          offset: const Offset(0, 2),
                                          blurRadius: 10.0),
                                    ],
                                  ),
                                  child: CheckboxListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    dense: true,
                                    activeColor: ColorResources.COLOR_PRIMARY,
                                    checkColor: ColorResources.COLOR_WHITE,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    value: cartProvider
                                        .getCheckBoxListTileModel[index]
                                        .isCheck,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        cartProvider
                                            .getCheckBoxListTileModel[index]
                                            .isCheck = value!;
                                      });
                                    },
                                    title: Container(
                                      height: 150,
                                      width: double.infinity,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          if (cartProvider
                                                  .getCheckBoxListTileModel[
                                                      index]
                                                  .cart
                                                  .plantId !=
                                              null)
                                            Container(
                                              height: 100,
                                              width: 100,
                                              child: CachedNetworkImage(
                                                filterQuality:
                                                    FilterQuality.high,
                                                imageUrl:
                                                    "${cartProvider.getCheckBoxListTileModel[index].plant!.imageURL!}",
                                                memCacheHeight: 200,
                                                memCacheWidth: 200,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  child: Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                    color: ColorResources
                                                        .COLOR_GRAY,
                                                  )),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          if (cartProvider
                                                  .getCheckBoxListTileModel[
                                                      index]
                                                  .cart
                                                  .productId !=
                                              null)
                                            Container(
                                              height: 100,
                                              width: 100,
                                              child: CachedNetworkImage(
                                                filterQuality:
                                                    FilterQuality.high,
                                                imageUrl:
                                                    "${cartProvider.getCheckBoxListTileModel[index].product!.imageURL!}",
                                                memCacheHeight: 200,
                                                memCacheWidth: 200,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  child: Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                    color: ColorResources
                                                        .COLOR_GRAY,
                                                  )),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (cartProvider
                                                      .getCheckBoxListTileModel[
                                                          index]
                                                      .cart
                                                      .plantId !=
                                                  null)
                                                Text(cartProvider
                                                            .getCheckBoxListTileModel[
                                                                index]
                                                            .plant!
                                                            .name!
                                                            .length >
                                                        10
                                                    ? cartProvider
                                                            .getCheckBoxListTileModel[
                                                                index]
                                                            .plant!
                                                            .name!
                                                            .substring(0, 10) +
                                                        ".."
                                                    : cartProvider
                                                        .getCheckBoxListTileModel[
                                                            index]
                                                        .plant!
                                                        .name!),
                                              if (cartProvider
                                                      .getCheckBoxListTileModel[
                                                          index]
                                                      .cart
                                                      .productId !=
                                                  null)
                                                Text(cartProvider
                                                            .getCheckBoxListTileModel[
                                                                index]
                                                            .product!
                                                            .name!
                                                            .length >
                                                        10
                                                    ? cartProvider
                                                            .getCheckBoxListTileModel[
                                                                index]
                                                            .product!
                                                            .name!
                                                            .substring(0, 10) +
                                                        ".."
                                                    : cartProvider
                                                        .getCheckBoxListTileModel[
                                                            index]
                                                        .product!
                                                        .name!),
                                              const SizedBox(height: 5),
                                              if (cartProvider
                                                      .getCheckBoxListTileModel[
                                                          index]
                                                      .cart
                                                      .plantId !=
                                                  null)
                                                Text("RM: " +
                                                    cartProvider
                                                        .getCheckBoxListTileModel[
                                                            index]
                                                        .plant!
                                                        .price!
                                                        .toStringAsFixed(2)),
                                              if (cartProvider
                                                      .getCheckBoxListTileModel[
                                                          index]
                                                      .cart
                                                      .productId !=
                                                  null)
                                                Text("RM: " +
                                                    cartProvider
                                                        .getCheckBoxListTileModel[
                                                            index]
                                                        .product!
                                                        .price!
                                                        .toStringAsFixed(2)),
                                              const SizedBox(height: 5),
                                              Container(
                                                height: 30,
                                                child: InputQty.int(
                                                  decoration:
                                                      QtyDecorationProps(
                                                    isBordered: false,
                                                    borderShape:
                                                        BorderShapeBtn.none,
                                                    btnColor: ColorResources
                                                        .COLOR_PRIMARY,
                                                    width: 12,
                                                    plusBtn: Icon(
                                                      Icons.add_box_outlined,
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
                                                  maxVal: 10000,
                                                  initVal: cartProvider
                                                      .getCheckBoxListTileModel[
                                                          index]
                                                      .cart
                                                      .quantity as num,
                                                  minVal: 1,
                                                  steps: 1,
                                                  onQtyChanged: (val) {
                                                    setState(() {
                                                      cartProvider
                                                          .getCheckBoxListTileModel[
                                                              index]
                                                          .cart
                                                          .quantity = val;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                );
        }),
      ),
    );
  }
}
