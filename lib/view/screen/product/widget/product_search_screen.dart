import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nurserygardenapp/providers/product_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:provider/provider.dart';

class ProductSearchScreen extends StatefulWidget {
  @override
  _ProductSearchScreenState createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  TextEditingController _searchController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white, // <-- SEE HERE
        ),
        backgroundColor: ColorResources.COLOR_PRIMARY,
        title: Container(
          height: 40,
          child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
            return TextField(
              onChanged: (value) {
                productProvider.getSearchTips(value);
              },
              onSubmitted: (value) {
                if (_searchController.text.isEmpty) {
                  EasyLoading.showError('Please enter the product name',
                      dismissOnTap: true,
                      duration: Duration(milliseconds: 500));
                  return;
                }
                FocusScope.of(context).unfocus();
                Navigator.pushNamed(context,
                    Routes.getProductSearchResultRoute(_searchController.text));
              },
              autofocus: true,
              cursorColor: Theme.of(context).primaryColor,
              controller: _searchController,
              focusNode: _focusNode,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.only(left: 10),
                  focusColor: Theme.of(context).primaryColor,
                  hintText: 'Search Product',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 14,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.search,
                    ),
                    onPressed: () {
                      if (_searchController.text.isEmpty) {
                        EasyLoading.showError('Please enter the product name',
                            dismissOnTap: true,
                            duration: Duration(milliseconds: 500));
                        return;
                      }
                      FocusScope.of(context).unfocus();
                      Navigator.pushNamed(
                          context,
                          Routes.getProductSearchResultRoute(
                              _searchController.text));
                    },
                  )),
            );
          }),
        ),
      ),
      body:
          Consumer<ProductProvider>(builder: (context, productProvider, child) {
        return ListView.builder(
          itemCount: productProvider.productSearchHint.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(
                    context,
                    Routes.getProductSearchResultRoute(
                        productProvider.productSearchHint[index]));
              },
              child: ListTile(
                title: Text(productProvider.productSearchHint[index]),
              ),
            );
          },
        );
      }),
    );
  }
}
