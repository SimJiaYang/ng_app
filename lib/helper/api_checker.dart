import 'package:flutter/material.dart';
import 'package:nurserygardenapp/data/model/response/api_response.dart';
import 'package:nurserygardenapp/providers/splash_provider.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/base/custom_snackbar.dart';
import 'package:provider/provider.dart';

class ApiChecker {
  static void checkApi(BuildContext context, ApiResponse apiResponse) {
    if (apiResponse.error == "Unauthenticated") {
      showCustomSnackBar(apiResponse.error, context);
      Provider.of<SplashProvider>(context, listen: false).removeSharedData();
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.getLoginRoute(), (route) => false);
    } else {
      String _errorMessage;
      if (apiResponse.error is String) {
        _errorMessage = apiResponse.error.toString();
      } else {
        _errorMessage = apiResponse.error;
      }
      showCustomSnackBar(_errorMessage, context);
    }
  }
}
