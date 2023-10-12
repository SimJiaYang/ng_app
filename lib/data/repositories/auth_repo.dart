import 'dart:async';
import 'package:dio/dio.dart';
import 'package:nurserygardenapp/data/dio/dio_client.dart';
import 'package:nurserygardenapp/data/exception/api_error_handler.dart';
import 'package:nurserygardenapp/data/model/response/api_response.dart';
import 'package:nurserygardenapp/data/model/auth_model.dart';
import 'package:nurserygardenapp/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> registration(AuthModel userModel) async {
    try {
      Response response = await dioClient.post(
        AppConstants.REGISTER_URI,
        data: userModel.toRegisterJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

// Login user
  Future<ApiResponse> login({String? email, String? password}) async {
    try {
      Response response = await dioClient.post(
        AppConstants.LOGIN_URI,
        data: {"email": email, "password": password},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // Logout user api
  Future<ApiResponse> logoutUser() async {
    try {
      Response response = await dioClient.get(AppConstants.LOGOUT_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for  user token
  Future<void> saveUserToken(String token) async {
    dioClient.token = token;
    dioClient.dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      await sharedPreferences.setString(AppConstants.TOKEN, token);
    } catch (e) {
      throw e;
    }
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }

  Future<bool> clearSharedData() async {
    await sharedPreferences.remove(AppConstants.TOKEN);
    await sharedPreferences.remove(AppConstants.USER_INFO);
    await sharedPreferences.remove(AppConstants.PLANT_TOKEN);
    await sharedPreferences.remove(AppConstants.PRODUCT_TOKEN);
    return true;
  }
}
