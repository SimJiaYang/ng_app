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
    print(params);
    final queryParameters = params.entries
        .where((entry) => entry.value != null && entry.value.isNotEmpty)
        .map((entry) => "${entry.key}=${Uri.encodeComponent(entry.value)}")
        .join('&');

    return queryParameters.isNotEmpty ? '?' + queryParameters : '';
  }
}
