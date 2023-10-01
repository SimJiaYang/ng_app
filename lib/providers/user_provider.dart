import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:nurserygardenapp/data/model/response/api_response.dart';
import 'package:nurserygardenapp/data/model/user_model.dart';
import 'package:nurserygardenapp/data/repositories/user_repo.dart';
import 'package:nurserygardenapp/helper/response_helper.dart';
import 'package:nurserygardenapp/util/app_constants.dart';
import 'package:nurserygardenapp/view/base/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  final UserRepo userRepo;
  final SharedPreferences sharedPreferences;

  UserProvider({required this.userRepo, required this.sharedPreferences});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  UserModel _userModel = UserModel();
  UserModel get userModel => _userModel;

  UserData _userData = UserData();
  UserData get userData => _userData;

  // Get User Information
  Future<bool> showUserInformation(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    bool result = false;
    ApiResponse apiResponse = await userRepo.showUserInformation();

    if (context.mounted) {
      result = ResponseHelper.responseHelper(context, apiResponse);
      if (result) {
        _userModel = UserModel.fromJson(apiResponse.response!.data);
        setUserInfo(apiResponse.response!.data!['data']);
        notifyListeners();
      }
    }
    _isLoading = false;
    notifyListeners();
    return result;
  }

  // Update User Information
  Future<bool> updateUserProfile(
      BuildContext context, UserData userinfo) async {
    _isSubmitting = true;
    notifyListeners();
    bool result = false;
    ApiResponse apiResponse = await userRepo.updateUserInformation(userinfo);

    if (context.mounted) {
      result = ResponseHelper.responseHelper(context, apiResponse);
      if (result) {
        showCustomSnackBar('Success', context,
            type: AppConstants.SNACKBAR_SUCCESS);
      }
    }

    _isSubmitting = false;
    notifyListeners();
    return result;
  }

  // ---------------------------User Profile Image Handling------------------------//
  Future<bool> upload(File file, String key, BuildContext context) async {
    bool result = false;
    _isUploading = true;
    notifyListeners();
    ApiResponse apiResponse = await userRepo.uploadUserAvatar(file, key);
    if (context.mounted) {
      result = ResponseHelper.responseHelper(context, apiResponse);
      if (result) {
        _imageUrl = apiResponse.response!.data['data']['image_link'];
        _imageName = apiResponse.response!.data['data']['image_name'];
      }
    }
    _isUploading = false;
    notifyListeners();
    return result;
  }

  String _imageUrl = '';
  String get imageUrl => _imageUrl;

  String _imageName = '';
  String get imageName => _imageName;

  resetImageUrl() {
    if (_imageUrl != '') {
      _imageUrl = '';
      _imageName = '';
    }
  }
  // ------------------------------------------------------------------------------//

  // Save user info
  Future<void> setUserInfo(userMap) async {
    try {
      await sharedPreferences.setString(
          AppConstants.USER_INFO, json.encode(userMap));
    } catch (e) {
      rethrow;
    }
  }

  UserData getUserInfo() {
    String uData = sharedPreferences.getString(AppConstants.USER_INFO) ?? '';
    if (uData.isNotEmpty) {
      _userData = UserData.fromJson(json.decode(uData));
    } else {
      _userData = new UserData();
    }
    return _userData;
  }
}
