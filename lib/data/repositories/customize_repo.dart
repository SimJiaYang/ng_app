import 'package:nurserygardenapp/data/dio/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomizeRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  CustomizeRepo({required this.dioClient, required this.sharedPreferences});

  // Future<ApiResponse> getCartItem(param) async {
  //   try {
  //     Response response = await dioClient.get('${AppConstants.CART_URI}$param');
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }
}
