import 'package:dio/dio.dart';
import 'package:nurserygardenapp/data/dio/dio_client.dart';
import 'package:nurserygardenapp/data/exception/api_error_handler.dart';
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
}
