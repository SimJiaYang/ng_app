import 'package:flutter/widgets.dart';
import 'package:nurserygardenapp/data/model/product_model.dart';
import 'package:nurserygardenapp/data/model/response/api_response.dart';
import 'package:nurserygardenapp/data/repositories/product_repo.dart';
import 'package:nurserygardenapp/helper/response_helper.dart';

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

    bool result = false;
    ApiResponse apiResponse = await productRepo.getProductList();

    if (context.mounted) {
      result = ResponseHelper.responseHelper(context, apiResponse);
      if (result) {
        _productModel = ProductModel.fromJson(apiResponse.response!.data);
        _productList = _productModel.data!.product!;
      }
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }
}
