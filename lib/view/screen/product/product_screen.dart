import 'package:flutter/material.dart';
import 'package:nurserygardenapp/providers/product_provider.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/base/circular_indicator.dart';
import 'package:nurserygardenapp/view/base/empty_data_widget.dart';
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
  bool _isFirstTime = true;

  // Param
  var params = {
    'limit': '8',
  };

  Future<void> _loadData({bool isLoadMore = false}) async {
    await product_prov
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
    _scrollController.dispose();
    super.dispose();
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
            'Product',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 18,
            ),
          ),
        ),
        body: SizedBox(
            height: size.height,
            width: size.width,
            child: Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
              return Column(children: [
                productProvider.productList.isEmpty &&
                        _isFirstTime &&
                        productProvider.isLoading
                    ? EmptyWidget(
                        large: true, isLoading: productProvider.isLoading)
                    : productProvider.productList.isEmpty &&
                            !productProvider.isLoading
                        ? Center(
                            child: Text(
                            "No Product",
                            style:
                                TextStyle(color: Colors.grey.withOpacity(0.5)),
                          ))
                        : Expanded(
                            child: RefreshIndicator(
                              onRefresh: () => _loadData(isLoadMore: false),
                              child: GridView.builder(
                                shrinkWrap: true,
                                controller: _scrollController,
                                physics: const BouncingScrollPhysics(),
                                itemCount: productProvider.productList.length +
                                    ((productProvider.isLoading &&
                                                productProvider
                                                        .productList.length >
                                                    8) ||
                                            productProvider
                                                .noMoreDataMessage.isNotEmpty
                                        ? 1
                                        : 0),
                                padding: const EdgeInsets.only(
                                    bottom: 70, left: 10, right: 10),
                                primary: false,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 3 / 4,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  if (index ==
                                          productProvider.productList.length &&
                                      _isLoadMore &&
                                      productProvider
                                          .noMoreDataMessage.isEmpty) {
                                    return const SizedBox(
                                        height: 50, child: CircularProgress());
                                  } else if (index ==
                                          productProvider.productList.length &&
                                      productProvider
                                          .noMoreDataMessage.isNotEmpty) {
                                    return Container(
                                      height: 60,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Center(
                                        child: Text(
                                            productProvider.noMoreDataMessage,
                                            style: TextStyle(
                                                color: Colors.grey
                                                    .withOpacity(0.5))),
                                      ),
                                    );
                                  } else {
                                    return ProductGridItem(
                                      key: ValueKey(productProvider.productList
                                          .elementAt(index)
                                          .id),
                                      product: productProvider.productList
                                          .elementAt(index),
                                      onTap: () async {
                                        await Navigator.pushNamed(
                                            context,
                                            Routes.getProductDetailRoute(
                                                productProvider.productList
                                                    .elementAt(index)
                                                    .id!
                                                    .toString()));
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
              ]);
            })));
  }
}
