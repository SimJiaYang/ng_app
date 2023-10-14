import 'package:flutter/material.dart';
import 'package:nurserygardenapp/providers/product_provider.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/base/empty_data_widget.dart';
import 'package:nurserygardenapp/view/base/empty_grid_item.dart';
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
  bool _isFirstTime = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Param
  var params = {
    'limit': '8',
  };

  Future<void> _loadData({bool isLoadMore = false}) async {
    await product_prov.listOfProduct(context, params, isLoadMore: isLoadMore);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
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
        body: SafeArea(
      child: SizedBox(
          height: size.height,
          width: size.width,
          child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                                style: TextStyle(
                                    color: Colors.grey.withOpacity(0.7),
                                    fontSize: 18),
                              ),
                            )
                          : Expanded(
                              child: RefreshIndicator(
                                key: _refreshIndicatorKey,
                                onRefresh: () => _loadData(isLoadMore: false),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  controller: _scrollController,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount:
                                      productProvider.productList.length +
                                          ((productProvider.isLoading &&
                                                  productProvider
                                                          .productList.length >=
                                                      8)
                                              ? 8
                                              : productProvider
                                                      .noMoreDataMessage
                                                      .isNotEmpty
                                                  ? 1
                                                  : 0),
                                  padding: (productProvider
                                              .noMoreDataMessage.isNotEmpty &&
                                          !productProvider.isLoading)
                                      ? EdgeInsets.all(10)
                                      : EdgeInsets.only(
                                          bottom: 235,
                                          left: 10,
                                          right: 10,
                                          top: 10),
                                  primary: false,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 3 / 4,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index >=
                                            productProvider
                                                .productList.length &&
                                        productProvider
                                            .noMoreDataMessage.isEmpty) {
                                      return EmptyGridItem();
                                    } else if (index ==
                                            productProvider
                                                .productList.length &&
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
                                        key: ValueKey(productProvider
                                            .productList
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
                                                    .toString(),
                                                "false",
                                              ));
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                ]);
          })),
    ));
  }
}
