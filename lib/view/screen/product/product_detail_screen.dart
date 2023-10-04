import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nurserygardenapp/data/model/product_model.dart';
import 'package:nurserygardenapp/providers/product_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/view/base/custom_space.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productID;
  const ProductDetailScreen({
    required this.productID,
    super.key,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late var product_prov = Provider.of<ProductProvider>(context, listen: false);
  late Product product = Product();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      return getProductInformation();
    });
  }

  getProductInformation() {
    product = product_prov.productList
        .firstWhere((element) => element.id.toString() == widget.productID);
    setState(() {
      isLoading = false;
    });
    print(product.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: []),
        body: SafeArea(
          child: Center(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SafeArea(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: ColorResources.COLOR_WHITE,
                              width: double.infinity,
                              child: CachedNetworkImage(
                                height: 280,
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
                                              color: ColorResources
                                                  .COLOR_PRIMARY)),
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
          ),
        ));
  }
}
