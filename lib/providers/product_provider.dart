import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:nurserygardenapp/data/model/product_model.dart';
import 'package:nurserygardenapp/data/model/response/api_response.dart';
import 'package:nurserygardenapp/data/repositories/product_repo.dart';
import 'package:nurserygardenapp/helper/response_helper.dart';
import 'package:nurserygardenapp/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepo productRepo;
  final SharedPreferences sharedPreferences;
  ProductProvider({required this.productRepo, required this.sharedPreferences});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ProductModel _productModel = ProductModel();
  ProductModel get productModel => _productModel;

  List<Product> _productList = [];
  List<Product> get productList => _productList;

  String _noMoreDataMessage = '';
  String get noMoreDataMessage => _noMoreDataMessage;

  /// ================== PRODUCT LIST ==================
  Future<bool> listOfProduct(BuildContext context, params,
      {bool isLoadMore = false, bool isLoad = true}) async {
    if (!isLoadMore) {
      _productList = [];
      _noMoreDataMessage = '';
    }

    bool result = false;
    String query = ResponseHelper.buildQuery(params);
    int limit = params['limit'] != null ? int.parse(params['limit']) : 8;

    _isLoading = isLoad;
    notifyListeners();

    ApiResponse apiResponse = await productRepo.getProductList(query);

    if (context.mounted) {
      result = ResponseHelper.responseHelper(context, apiResponse);
      if (result) {
        _productModel = ProductModel.fromJson(apiResponse.response!.data);
        _productList = _productModel.data!.productsList!.product ?? [];
        // setProductListInfo(_productList);
        if (_productList.length < limit && limit > 8) {
          _noMoreDataMessage = AppConstants.NO_MORE_DATA;
        }
      }
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  /// ================== PRODUCT SAVE IN LOCAL ==================
  Future<void> setProductListInfo(productInfo) async {
    try {
      await sharedPreferences.setString(
          AppConstants.PRODUCT_TOKEN, json.encode(productInfo));
    } catch (e) {
      rethrow;
    }
  }

  void getProductListInfo() {
    String productInfo =
        sharedPreferences.getString(AppConstants.PRODUCT_TOKEN) ?? '';
    if (productInfo.isNotEmpty) {
      List<dynamic> decodedData = json.decode(productInfo);
      List<Product> productListInfo =
          decodedData.map((item) => Product.fromJson(item)).toList();
      _productList = productListInfo;
      notifyListeners();
    } else {
      _productList = [];
      notifyListeners();
    }
  }

  Future<void> clearProductListData() async {
    await sharedPreferences.remove(AppConstants.PRODUCT_TOKEN);
  }
}
