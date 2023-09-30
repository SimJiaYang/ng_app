import 'package:flutter/widgets.dart';
import 'package:nurserygardenapp/data/model/response/api_response.dart';
import 'package:nurserygardenapp/data/model/user_model.dart';
import 'package:nurserygardenapp/data/repositories/user_repo.dart';
import 'package:nurserygardenapp/helper/api_checker.dart';
import 'package:nurserygardenapp/util/app_constants.dart';
import 'package:nurserygardenapp/view/base/custom_snackbar.dart';

class UserProvider extends ChangeNotifier {
  final UserRepo userRepo;
  UserProvider({required this.userRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  UserModel _userModel = UserModel();
  UserModel get userModel => _userModel;

  // Get User Information
  Future<bool> showUserInformation(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await userRepo.showUserInformation();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      if (apiResponse.response!.data['success']) {
        _userModel = UserModel.fromJson(apiResponse.response!.data);
      } else {
        showCustomSnackBar(apiResponse.response!.data!['error'], context);
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Edit User Information
  Future<bool> updateUserProfile(
      BuildContext context, UserData userinfo) async {
    _isSubmitting = true;
    notifyListeners();
    ApiResponse apiResponse = await userRepo.updateUserInformation(userinfo);

    if (apiResponse.response == null ||
        apiResponse.response!.statusCode != 200) {
      ApiChecker.checkApi(context, apiResponse);
      _isSubmitting = false;
      notifyListeners();
      return false;
    } else {
      if (!apiResponse.response!.data['success']) {
        showCustomSnackBar(apiResponse.response!.data!['error'], context);
        _isSubmitting = false;
        notifyListeners();
        return false;
      } else {
        showCustomSnackBar('Success', context,
            type: AppConstants.SNACKBAR_SUCCESS);
        _isSubmitting = false;
        notifyListeners();
        return true;
      }
    }
  }
}
