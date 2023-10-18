import 'package:dio/dio.dart';
import 'package:nurserygardenapp/data/dio/dio_client.dart';
import 'package:nurserygardenapp/data/exception/api_error_handler.dart';
import 'package:nurserygardenapp/data/model/cart_model.dart';
import 'package:nurserygardenapp/data/model/response/api_response.dart';
import 'package:nurserygardenapp/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  CartRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getCartItem(param) async {
    try {
      Response response = await dioClient.get('${AppConstants.CART_URI}$param');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addToCart(Cart cart) async {
    try {
      Response response = await dioClient
          .post('${AppConstants.ADD_TO_CART_URI}', data: cart.toJson());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> deleteCartItem(String id) async {
    try {
      Response response = await dioClient
          .post('${AppConstants.DELETE_CART_URI}', data: {"id": id});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
