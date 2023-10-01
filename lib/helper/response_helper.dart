import 'package:flutter/material.dart';
import 'package:nurserygardenapp/data/model/response/api_response.dart';

import '../helper/api_checker.dart';
import '../view/base/custom_snackbar.dart';

class ResponseHelper {
  static bool responseHelper(BuildContext context, ApiResponse apiResponse) {
    bool result = true;
    if (apiResponse.response == null ||
        apiResponse.response!.statusCode != 200) {
      result = false;
      ApiChecker.checkApi(context, apiResponse);
    } else if (!apiResponse.response!.data['success']) {
      result = false;
      showCustomSnackBar(apiResponse.response!.data['error'], context);
    }
    return result;
  }

  static String buildQuery(params) {
    List paramList = params.entries
        .where((entry) => entry.value != null && entry.value != "")
        .map((entry) => "${entry.key}=${entry.value}")
        .toList();

    return paramList.isNotEmpty ? "?${paramList.join("&")}" : "";
  }
}
