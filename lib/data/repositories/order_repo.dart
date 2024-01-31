import 'package:dio/dio.dart';
import 'package:nurserygardenapp/data/dio/dio_client.dart';
import 'package:nurserygardenapp/data/exception/api_error_handler.dart';
import 'package:nurserygardenapp/data/model/cart_model.dart';
import 'package:nurserygardenapp/data/model/delivery_model.dart';
import 'package:nurserygardenapp/data/model/order_model.dart';
import 'package:nurserygardenapp/data/model/response/api_response.dart';
import 'package:nurserygardenapp/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  OrderRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getOrder(param) async {
    try {
      Response response =
          await dioClient.get('${AppConstants.ORDER_URI}$param');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getOrderDetail(param) async {
    try {
      Response response =
          await dioClient.get('${AppConstants.ORDER_DETAIL_URI}$param');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addOrder(List<Cart> cartList, String address) async {
    try {
      final List<Map<String, dynamic>> cartListJson =
          cartList.map((cart) => cart.toJson()).toList();

      Response response = await dioClient.post(
        AppConstants.ORDER_CREATE_URL,
        data: {"cart_list": cartListJson, "address": address},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getReceipt(param) async {
    try {
      Response response =
          await dioClient.get('${AppConstants.ORDER_RECEIPT_URI}$param');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> cancelOrder(Order order) async {
    try {
      Response response = await dioClient
          .post('${AppConstants.ORDER_CANCEL_URI}', data: order.toJson());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> changeOrderAddress(int orderID, String address) async {
    try {
      Response response =
          await dioClient.post(AppConstants.ORDER_CHANGE_ADDRESS_URI, data: {
        "id": orderID,
        "address": address,
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> receiveOrder(String orderID) async {
    try {
      Response response =
          await dioClient.post('${AppConstants.ORDER_RECEIVE_URI}', data: {
        "id": orderID,
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
