import 'package:flutter/material.dart';
import 'package:nurserygardenapp/data/model/response/api_response.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/base/custom_snackbar.dart';

class ApiChecker {
  static void checkApi(BuildContext context, ApiResponse apiResponse) {
    if (apiResponse.error is! String &&
        apiResponse.error == 'Unauthenticated.') {
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.getLoginRoute(), (route) => false);
    } else {
      String _errorMessage;
      if (apiResponse.error is String) {
        _errorMessage = apiResponse.error.toString();
      } else {
        _errorMessage = apiResponse.error;
      }
      print(_errorMessage);
      showCustomSnackBar(_errorMessage, context);
    }
  }
}
