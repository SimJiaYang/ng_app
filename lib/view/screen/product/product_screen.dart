import 'package:flutter/material.dart';
import 'package:nurserygardenapp/providers/product_provider.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/screen/product/widget/product_grid_item.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late ProductProvider product_prov =
      Provider.of<ProductProvider>(context, listen: false);

  final _scrollController = ScrollController();
  bool _isEmptyProduct = false;
  bool _isLoadMore = false;

  // Param
  var params = {
    'limit': '8',
  };

  void _loadData({bool isLoadMore = false}) {
    if (!context.mounted) return;
    if (context.mounted) {
      product_prov
          .listOfProduct(context, params, isLoadMore: isLoadMore)
          .then((value) => {
                setState(() {
                  _isLoadMore = false;
                }),
                if (product_prov.productList.isEmpty)
                  {
                    setState(() {
                      _isEmptyProduct = true;
                    })
                  }
              });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _isLoadMore = true;
      });
      if (product_prov.productList.length < int.parse(params['limit']!)) return;
      int currentLimit = int.parse(params['limit']!);
      currentLimit += 8;
      params['limit'] = currentLimit.toString();
      _loadData(isLoadMore: true);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Product',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 18,
            ),
          ),
        ),
        body: Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
          if (_isEmptyProduct && productProvider.productList.isEmpty) {
            return Center(
                child: Text(
              "No Product",
              style: TextStyle(color: Colors.grey.withOpacity(0.5)),
            ));
          } else {
            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
                    physics: BouncingScrollPhysics(),
                    itemCount: productProvider.productList.length +
                        ((productProvider.isLoading &&
                                    productProvider.productList.length > 8) ||
                                productProvider.noMoreDataMessage.isNotEmpty
                            ? 1
                            : 0),
                    padding: const EdgeInsets.all(10),
                    primary: false,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == productProvider.productList.length &&
                          productProvider.noMoreDataMessage.isEmpty) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                          ),
                        );
                      } else if (index == productProvider.productList.length &&
                          productProvider.noMoreDataMessage.isNotEmpty) {
                        return Container(
                          height: 60,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Text(productProvider.noMoreDataMessage,
                                style: TextStyle(
                                    color: Colors.grey.withOpacity(0.5))),
                          ),
                        );
                      } else {
                        return ProductGridItem(
                          key: ValueKey(
                              productProvider.productList.elementAt(index).id),
                          product: productProvider.productList.elementAt(index),
                          onTap: () async {
                            await Navigator.pushNamed(
                                context,
                                Routes.getProductDetailRoute(productProvider
                                    .productList
                                    .elementAt(index)
                                    .id!
                                    .toString()));
                          },
                        );
                      }
                    },
                  ),
                ),
                if (_isLoadMore && productProvider.noMoreDataMessage.isEmpty)
                  Container(
                    color: Colors.white.withOpacity(0),
                    width: double.infinity,
                    height: 60,
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          }
        }));
  }
}
