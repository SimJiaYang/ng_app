import 'package:flutter/material.dart';
import 'package:nurserygardenapp/data/model/product_model.dart';
import 'package:nurserygardenapp/providers/product_provider.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/drawer/drawer_widget.dart';
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

  List<Product> productList = [];
  bool hasProduct = true;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProductList();
    });
  }

  Future<void> getProductList() async {
    bool success = await product_prov.getProductList(context);
    if (success) {
      productList = await product_prov.productList;
      debugPrint("Product List Length: " + productList.length.toString());
      setState(() {
        hasProduct = true;
      });
    } else {
      setState(() {
        hasProduct = false;
      });
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
        body: Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
          return productProvider.isLoading
              ? Center(child: CircularProgressIndicator())
              : !hasProduct
                  ? Center(child: Text("No Product Found"))
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
                            childAspectRatio: 3 / 4,
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
