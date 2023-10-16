import 'package:flutter/cupertino.dart';
import 'package:nurserygardenapp/data/model/cart_model.dart';
import 'package:nurserygardenapp/data/model/plant_model.dart';
import 'package:nurserygardenapp/data/model/product_model.dart';
import 'package:nurserygardenapp/data/model/response/api_response.dart';
import 'package:nurserygardenapp/data/repositories/cart_repo.dart';
import 'package:nurserygardenapp/helper/response_helper.dart';
import 'package:nurserygardenapp/util/app_constants.dart';
import 'package:nurserygardenapp/view/base/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  final CartRepo cartRepo;
  final SharedPreferences sharedPreferences;

  CartProvider({required this.cartRepo, required this.sharedPreferences});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  CartModel _cartModel = CartModel();
  CartModel get cartModel => _cartModel;

  List<Cart> _cartItem = [];
  List<Cart> get cartItem => _cartItem;

  String _noMoreDataMessage = '';
  String get noMoreDataMessage => _noMoreDataMessage;

  List<CheckBoxListTileModel> _checkBoxListTileModel = [];
  List<CheckBoxListTileModel> get getCheckBoxListTileModel =>
      _checkBoxListTileModel;

  List<Plant> _cartPlantList = [];
  List<Plant> get getCartPlantList => _cartPlantList;
  List<Product> _cartProductList = [];
  List<Product> get getCartProductList => _cartProductList;

  /// ================== CART LIST ==================
  Future<bool> getCartItem(BuildContext context, params,
      {bool isLoadMore = false, bool isLoad = true}) async {
    if (!isLoadMore) {
      _cartItem = [];
      _noMoreDataMessage = '';
    }

    bool result = false;
    String query = ResponseHelper.buildQuery(params);
    int limit = params['limit'] != null ? int.parse(params['limit']) : 8;

    _isLoading = isLoad;
    notifyListeners();

    ApiResponse apiResponse = await cartRepo.getCartItem(query);

    if (context.mounted) {
      result = ResponseHelper.responseHelper(context, apiResponse);
      if (result) {
        _cartModel = CartModel.fromJson(apiResponse.response!.data);
        _cartItem = _cartModel.data!.cartList!.cart ?? [];
        _cartPlantList = _cartModel.data!.plant ?? [];
        _cartProductList = _cartModel.data!.product ?? [];
        _checkBoxListTileModel = _cartItem
            .map((e) => CheckBoxListTileModel(
                cart: e,
                title: e.quantity.toString(),
                isCheck: false,
                plant: e.plantId != null
                    ? _cartPlantList.firstWhere(
                        (element) => element.id == e.plantId,
                      )
                    : null,
                product: e.productId != null
                    ? _cartProductList.firstWhere(
                        (element) => element.id == e.productId,
                      )
                    : null))
            .toList();
        if (_cartItem.length < limit && limit > 8) {
          _noMoreDataMessage = AppConstants.NO_MORE_DATA;
        }
      }
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  // ADD TO CART ** UPDATE CART
  Future<bool> addToCart(BuildContext context, Cart cart) async {
    bool result = false;
    _isLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await cartRepo.addToCart(cart);
    if (context.mounted) {
      result = ResponseHelper.responseHelper(context, apiResponse);
      if (result) {
        showCustomSnackBar('Success', context,
            type: AppConstants.SNACKBAR_SUCCESS);
      }
    }
    _isLoading = false;
    notifyListeners();
    return result;
  }
}
