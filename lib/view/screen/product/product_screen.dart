import 'package:flutter/material.dart';
import 'package:nurserygardenapp/data/model/product_model.dart';
import 'package:nurserygardenapp/providers/product_provider.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/base/drawer_widget.dart';
import 'package:nurserygardenapp/view/screen/product/widget/product_grid_item.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late var product_prov;
  List<Product> productList = [];

  @override
  void initState() {
    super.initState();
    product_prov = Provider.of<ProductProvider>(context, listen: false);
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProductList();
    });
  }

  Future<void> getProductList() async {
    bool success = await product_prov.getProductList(context);
    if (success) {
      productList = await product_prov.productList;
      print(productList);
    } else {
      productList = [];
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
        drawer: DrawerWidget(size: size),
        body: Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
          return productProvider.isLoading
              ? Center(child: CircularProgressIndicator())
              : productList.isEmpty
                  ? Center(
                      child: Text(
                          "Some error happened,\n Please try again later."))
                  : SafeArea(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: GridView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: productList.length,
                          padding: const EdgeInsets.all(10),
                          primary: false,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2 / 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return ProductGridItem(
                              key: ValueKey(productList[index].id),
                              product: productList[index],
                              onTap: () {
                                Navigator.pushNamed(
                                    context,
                                    Routes.getProductDetailRoute(
                                        productList[index].id!.toString()));
                              },
                            );
                          },
                        ),
                      ),
                    );
        }));
  }
}
