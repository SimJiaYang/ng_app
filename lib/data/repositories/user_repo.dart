import 'dart:async';
import 'package:dio/dio.dart';
import 'package:nurserygardenapp/data/dio/dio_client.dart';
import 'package:nurserygardenapp/data/exception/api_error_handler.dart';
import 'package:nurserygardenapp/data/model/response/api_response.dart';
import 'package:nurserygardenapp/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  UserRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> showUserInformation() async {
    try {
      Response response = await dioClient.get(
        AppConstants.PROFILE_URI,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
