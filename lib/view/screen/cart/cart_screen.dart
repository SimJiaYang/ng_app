import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nurserygardenapp/data/model/cart_model.dart';
import 'package:nurserygardenapp/data/model/plant_model.dart';
import 'package:nurserygardenapp/providers/cart_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/base/empty_data_widget.dart';
import 'package:provider/provider.dart';
import 'package:quantity_input/quantity_input.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartProvider cart_prov =
      Provider.of<CartProvider>(context, listen: false);
  int simpleIntInput = 1;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'My Cart',
          style: TextStyle(color: ColorResources.COLOR_WHITE),
        ),
        leading: const BackButton(
          color: Colors.white, // <-- SEE HERE
        ),
        backgroundColor: ColorResources.COLOR_PRIMARY,
      ),
      body: Consumer<CartProvider>(builder: (context, cartProvider, child) {
        return ListView.builder(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: cartProvider.getCheckBoxListTileModel.length +
              (cartProvider.isLoading &&
                      cartProvider.getCheckBoxListTileModel.length >= 8
                  ? 1
                  : 0),
          itemBuilder: (BuildContext context, int index) {
            if (cartProvider.noMoreDataMessage.isEmpty &&
                cartProvider.isLoading) {
              return EmptyWidget(
                large: true,
                isLoading: cartProvider.isLoading,
              );
            } else {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Dismissible(
                      key: ValueKey(
                          cartProvider.getCheckBoxListTileModel[index].cart.id),
                      child: GestureDetector(
                        onTap: () {
                          if (cartProvider.getCheckBoxListTileModel[index].cart
                                  .plantId !=
                              null)
                            Navigator.pushNamed(
                                context,
                                Routes.getPlantDetailRoute(
                                    cartProvider.getCheckBoxListTileModel[index]
                                        .plant!.id!
                                        .toString(),
                                    "false",
                                    "true"));
                          if (cartProvider.getCheckBoxListTileModel[index].cart
                                  .productId !=
                              null)
                            Navigator.pushNamed(
                                context,
                                Routes.getProductDetailRoute(
                                    cartProvider.getCheckBoxListTileModel[index]
                                        .product!.id!
                                        .toString(),
                                    'true'));
                        },
                        child: CheckboxListTile(
                          dense: true,
                          activeColor: ColorResources.COLOR_PRIMARY,
                          checkColor: ColorResources.COLOR_WHITE,
                          controlAffinity: ListTileControlAffinity.leading,
                          value: cartProvider
                              .getCheckBoxListTileModel[index].isCheck,
                          onChanged: (bool? value) {
                            setState(() {
                              cartProvider.getCheckBoxListTileModel[index]
                                  .isCheck = value!;
                            });
                          },
                          title: Container(
                            height: 150,
                            width: double.infinity,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (cartProvider.getCheckBoxListTileModel[index]
                                        .cart.plantId !=
                                    null)
                                  Container(
                                    height: 100,
                                    width: 100,
                                    child: CachedNetworkImage(
                                      filterQuality: FilterQuality.high,
                                      imageUrl:
                                          "${cartProvider.getCheckBoxListTileModel[index].plant!.imageURL!}",
                                      memCacheHeight: 200,
                                      memCacheWidth: 200,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                      ),
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
                                if (cartProvider.getCheckBoxListTileModel[index]
                                        .cart.productId !=
                                    null)
                                  Container(
                                    height: 100,
                                    width: 100,
                                    child: CachedNetworkImage(
                                      filterQuality: FilterQuality.high,
                                      imageUrl:
                                          "${cartProvider.getCheckBoxListTileModel[index].product!.imageURL!}",
                                      memCacheHeight: 200,
                                      memCacheWidth: 200,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                      ),
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
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (cartProvider
                                            .getCheckBoxListTileModel[index]
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
                                              .getCheckBoxListTileModel[index]
                                              .plant!
                                              .name!),
                                    if (cartProvider
                                            .getCheckBoxListTileModel[index]
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
                                              .getCheckBoxListTileModel[index]
                                              .product!
                                              .name!),
                                    if (cartProvider
                                            .getCheckBoxListTileModel[index]
                                            .cart
                                            .plantId !=
                                        null)
                                      Text(cartProvider
                                          .getCheckBoxListTileModel[index]
                                          .plant!
                                          .price!
                                          .toStringAsFixed(2)),
                                    if (cartProvider
                                            .getCheckBoxListTileModel[index]
                                            .cart
                                            .productId !=
                                        null)
                                      Text(cartProvider
                                          .getCheckBoxListTileModel[index]
                                          .product!
                                          .price!
                                          .toStringAsFixed(2)),
                                    QuantityInput(
                                        inputWidth: 70,
                                        // label: 'Simple int input',
                                        value: cartProvider
                                            .getCheckBoxListTileModel[index]
                                            .cart
                                            .quantity,
                                        onChanged: (value) => setState(
                                            () =>
                                                cartProvider
                                                        .getCheckBoxListTileModel[
                                                            index]
                                                        .cart
                                                        .quantity =
                                                    int.parse(value.replaceAll(
                                                        ',', '')))),
                                  ],
                                ),
                              ],
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
    );
  }
}
