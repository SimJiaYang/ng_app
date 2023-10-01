import 'package:flutter/cupertino.dart';
import 'package:nurserygardenapp/data/model/response/api_response.dart';
import 'package:nurserygardenapp/data/model/auth_model.dart';
import 'package:nurserygardenapp/data/repositories/auth_repo.dart';
import 'package:nurserygardenapp/helper/api_checker.dart';
import 'package:nurserygardenapp/helper/response_helper.dart';
import '../view/base/custom_snackbar.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepo authRepo;

  AuthProvider({required this.authRepo});

  String userToken = '';

  // for registration section
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLogedIn = false;
  bool get isLogedIn => _isLogedIn;

  String _registrationErrorMessage = '';

  updateRegistrationErrorMessage(String message) {
    _registrationErrorMessage = message;
    notifyListeners();
  }

  Future<bool> login(
      String email, String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    bool result = false;
    ApiResponse apiResponse =
        await authRepo.login(email: email, password: password);

    if (context.mounted) {
      result = ResponseHelper.responseHelper(context, apiResponse);
      if (result) {
        print("Login -->" + apiResponse.response!.data['data']['token']);
        Map map = apiResponse.response!.data;
        String token = map['data']['token'];
        print(token);
        authRepo.saveUserToken(token);
      }
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  Future<bool> logout(BuildContext context) async {
    _isLoading = true;
    bool _resResult = false;
    notifyListeners();
    ApiResponse apiResponse = await authRepo.logoutUser();
    print(apiResponse.response);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      if (apiResponse.response!.data['success']) {
        _resResult = true;
        authRepo.clearSharedData();
      } else {
        _isLoading = false;
        notifyListeners();
        showCustomSnackBar(apiResponse.response!.data!['error'], context);
        return false;
      }
    } else {
      _isLoading = false;
      notifyListeners();
      ApiChecker.checkApi(context, apiResponse);
      return false;
    }
    notifyListeners();
    _isLoading = false;
    return _resResult;
  }

  Future<bool> registration(AuthModel userModel, BuildContext context) async {
    bool _resResult = false;
    _isLoading = true;
    _registrationErrorMessage = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo.registration(userModel);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      if (apiResponse.response!.data['success']) {
        Map map = apiResponse.response!.data;
        String token = map['data'];
        print(token);
        authRepo.saveUserToken(token);
        _resResult = true;
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
    return _resResult;
  }

  // for login section
  String _loginErrorMessage = '';

  String get loginErrorMessage => _loginErrorMessage;

  // for forgot password
  bool _isForgotPasswordLoading = false;

  bool get isForgotPasswordLoading => _isForgotPasswordLoading;

  // for phone verification
  bool _isPhoneNumberVerificationButtonLoading = false;

  bool get isPhoneNumberVerificationButtonLoading =>
      _isPhoneNumberVerificationButtonLoading;
  String _verificationMsg = '';

  String get verificationMessage => _verificationMsg;
  String _email = '';
  String _phone = '';

  String get email => _email;
  String get phone => _phone;

  updateEmail(String email) {
    _email = email;
    notifyListeners();
  }

  updatePhone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  void clearVerificationMessage() {
    _verificationMsg = '';
  }

  Future<bool> checkUserLogin() async {
    bool login = false;
    userToken = authRepo.getUserToken();
    if (userToken != '') {
      login = true;
    } else {
      login = false;
    }
    _isLogedIn = login;
    return login;
  }

  // for verification Code
  String _verificationCode = '';

  String get verificationCode => _verificationCode;
  bool _isEnableVerificationCode = false;

  bool get isEnableVerificationCode => _isEnableVerificationCode;

  updateVerificationCode(String query) {
    if (query.length == 5) {
      _isEnableVerificationCode = true;
    } else {
      _isEnableVerificationCode = false;
    }
    _verificationCode = query;
    notifyListeners();
  }

  // for Remember Me Section

  bool _isActiveRememberMe = false;

  bool get isActiveRememberMe => _isActiveRememberMe;

  toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    notifyListeners();
  }
}
