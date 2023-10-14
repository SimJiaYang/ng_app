import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nurserygardenapp/data/model/cart_model.dart';
import 'package:nurserygardenapp/data/model/plant_model.dart';
import 'package:nurserygardenapp/providers/cart_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/view/base/empty_data_widget.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartProvider cart_prov =
      Provider.of<CartProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
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
          shrinkWrap: true,
          itemCount: cartProvider.getCheckBoxListTileModel.length,
          itemBuilder: (BuildContext cOntext, int index) {
            return cartProvider.isLoading && cartProvider.cartItem.isEmpty
                ? EmptyWidget(
                    large: true,
                    isLoading: cartProvider.isLoading,
                  )
                : Column(
                    children: [
                      Dismissible(
                        key: ValueKey(cartProvider
                            .getCheckBoxListTileModel[index].cart.id),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: CheckboxListTile(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (cartProvider
                                          .getCheckBoxListTileModel[index]
                                          .cart
                                          .plantId !=
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
                                  if (cartProvider
                                          .getCheckBoxListTileModel[index]
                                          .cart
                                          .productId !=
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
                                  if (cartProvider
                                          .getCheckBoxListTileModel[index]
                                          .cart
                                          .plantId !=
                                      null)
                                    Column(
                                      children: [
                                        Text(cartProvider
                                            .getCheckBoxListTileModel[index]
                                            .plant!
                                            .name!),
                                        Text(cartProvider
                                            .getCheckBoxListTileModel[index]
                                            .plant!
                                            .price!
                                            .toStringAsFixed(2)),
                                      ],
                                    ),

                                  if (cartProvider
                                          .getCheckBoxListTileModel[index]
                                          .cart
                                          .productId !=
                                      null)
                                    Column(
                                      children: [
                                        Text(cartProvider
                                            .getCheckBoxListTileModel[index]
                                            .product!
                                            .name!),
                                        Text(cartProvider
                                            .getCheckBoxListTileModel[index]
                                            .product!
                                            .price!
                                            .toStringAsFixed(2)),
                                      ],
                                    ),
                                  // SizedBox(
                                  //   width: 10,
                                  // ),
                                  // Text(cartProvider
                                  //     .getCheckBoxListTileModel[index].cart.price!
                                  //     .toStringAsFixed(2))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
          },
        );
      }),
    );
  }
}
