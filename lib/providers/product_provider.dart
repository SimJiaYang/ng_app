import 'package:flutter/widgets.dart';
import 'package:nurserygardenapp/data/model/product_model.dart';
import 'package:nurserygardenapp/data/model/response/api_response.dart';
import 'package:nurserygardenapp/data/repositories/product_repo.dart';
import 'package:nurserygardenapp/helper/api_checker.dart';
import 'package:nurserygardenapp/view/base/custom_snackbar.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepo productRepo;
  ProductProvider({required this.productRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ProductModel _productModel = ProductModel();
  ProductModel get productModel => _productModel;

  List<Product> _productList = [];
  List<Product> get productList => _productList;

  Future<bool> getProductList(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await productRepo.getProductList();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      if (apiResponse.response!.data['success']) {
        _productModel = ProductModel.fromJson(apiResponse.response!.data);
        _productList = _productModel.data!.product!;
      } else {
        showCustomSnackBar(apiResponse.response!.data!['error'], context);
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    _isLoading = false;
    notifyListeners();
    return true;
  }
}
