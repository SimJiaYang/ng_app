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

  List<Cart> _cartList = [];
  List<Cart> get cartItem => _cartList;

  String _noMoreDataMessage = '';
  String get noMoreDataMessage => _noMoreDataMessage;

  List<Plant> _cartPlantList = [];
  List<Plant> get getCartPlantList => _cartPlantList;
  List<Product> _cartProductList = [];
  List<Product> get getCartProductList => _cartProductList;

  List<Cart> _addedCartList = [];
  List<Cart> get addedCartList => _addedCartList;

  /// ================== CART LIST ==================
  Future<bool> getCartItem(BuildContext context, params,
      {bool isLoadMore = false, bool isLoad = true}) async {
    if (!isLoadMore) {
      _cartList = [];
      _addedCartList = [];
      _cartPlantList = [];
      _cartProductList = [];
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
        _cartList = _cartModel.data!.cartList!.cart ?? [];
        _cartPlantList = _cartModel.data!.plant ?? [];
        _cartProductList = _cartModel.data!.product ?? [];
        if (_cartList.length < limit && limit > 8) {
          _noMoreDataMessage = AppConstants.NO_MORE_DATA;
        }
      }
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  // ADD TO CART ** UPDATE CART
  List<Cart> _returnAddCart = [];
  List<Cart> get returnAddCart => _returnAddCart;

  Future<bool> addToCart(BuildContext context, Cart cart,
      {bool ismsg = true, bool isCart = true}) async {
    bool result = false;
    _isLoading = true;
    _returnAddCart = [];
    notifyListeners();

    ApiResponse apiResponse = await cartRepo.addToCart(cart);
    if (context.mounted) {
      result = ResponseHelper.responseHelper(context, apiResponse);
      if (result) {
        _returnAddCart =
            CartModel.fromJson(apiResponse.response!.data).data!.returnCart!;
        if (ismsg) {
          showCustomSnackBar('Success', context,
              type: AppConstants.SNACKBAR_SUCCESS);
        }
      }
    }
    _isLoading = false;
    notifyListeners();
    return result;
  }

  // UPDATE CART
  Future<bool> updateCart(BuildContext context, Cart cart) async {
    bool result = false;
    notifyListeners();

    ApiResponse apiResponse = await cartRepo.updateCartItem(cart);
    if (context.mounted) {
      result = ResponseHelper.responseHelper(context, apiResponse);
    }
    notifyListeners();
    return result;
  }

  // DELETE CART
  Future<bool> deleteCart(BuildContext context, String id) async {
    bool result = false;
    notifyListeners();

    ApiResponse apiResponse = await cartRepo.deleteCartItem(id);
    if (context.mounted) {
      result = ResponseHelper.responseHelper(context, apiResponse);
    }
    notifyListeners();
    return result;
  }

  void clearCartList() {
    _addedCartList = [];
    notifyListeners();
  }

  void addCartList(Cart cart) {
    clearCartList();
    _addedCartList = [cart];
    notifyListeners();
  }
}
