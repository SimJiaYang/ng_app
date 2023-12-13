import 'package:dio/dio.dart';
import 'package:nurserygardenapp/data/dio/dio_client.dart';
import 'package:nurserygardenapp/data/exception/api_error_handler.dart';
import 'package:nurserygardenapp/data/model/response/api_response.dart';
import 'package:nurserygardenapp/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PayRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  PayRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getPaymentIntentID(String orderID) async {
    try {
      Response response = await dioClient
          .post(AppConstants.PAYMENT_URI, data: {'order_id': orderID});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> handleSuccessPayment(String clientSecret) async {
    try {
      Response response = await dioClient.post(
          AppConstants.PAYMENT_SUCCESS_HANDLING,
          data: {'client_secret': clientSecret});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getBiddingPaymentIntentID(
      String biddingID, double amount) async {
    try {
      Response response = await dioClient.post(
          AppConstants.BIDDING_PAYMENT_INTENT_URI,
          data: {'bidding_id': biddingID, 'amount': amount});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> handleBiddingPayment(
      String clientSecret, String bidDetailID) async {
    try {
      Response response = await dioClient.post(AppConstants.BIDDING_PAYMENT_URI,
          data: {'client_secret': clientSecret, 'bid_detail_id': bidDetailID});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
