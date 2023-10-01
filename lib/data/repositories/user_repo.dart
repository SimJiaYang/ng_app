import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:nurserygardenapp/data/dio/dio_client.dart';
import 'package:nurserygardenapp/data/exception/api_error_handler.dart';
import 'package:nurserygardenapp/data/model/response/api_response.dart';
import 'package:nurserygardenapp/data/model/user_model.dart';
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

  Future<ApiResponse> updateUserInformation(UserData userData) async {
    try {
      Response response = await dioClient.post(AppConstants.PROFILE_UPDATE_URI,
          data: userData.toJson());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> uploadUserAvatar(File file, String key) async {
    try {
      Response response = await dioClient.uploadImage(
        file,
        key,
        AppConstants.PROFILE_IMAGE_UPLOAD_URI,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
