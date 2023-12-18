import 'package:dio/dio.dart';
import 'package:nurserygardenapp/data/dio/dio_client.dart';
import 'package:nurserygardenapp/data/exception/api_error_handler.dart';
import 'package:nurserygardenapp/data/model/response/api_response.dart';
import 'package:nurserygardenapp/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiddingRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  BiddingRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getBidddingList(param) async {
    try {
      Response response =
          await dioClient.get('${AppConstants.BIDDING_LIST_URI}$param');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getBidddingDetail(param) async {
    try {
      Response response =
          await dioClient.get('${AppConstants.BIDDING_DETAIL_URI}$param');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getBidddingRefundList(param) async {
    try {
      Response response =
          await dioClient.get('${AppConstants.BIDDING_REFUND_URI}$param');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
