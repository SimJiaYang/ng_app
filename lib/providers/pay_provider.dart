import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:nurserygardenapp/data/model/payment_model.dart';
import 'package:nurserygardenapp/data/model/response/api_response.dart';
import 'package:nurserygardenapp/data/repositories/pay_repo.dart';
import 'package:nurserygardenapp/helper/response_helper.dart';
import 'package:nurserygardenapp/view/base/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PayProvider extends ChangeNotifier {
  final PayRepo payRepo;
  final SharedPreferences sharedPreferences;

  PayProvider({required this.payRepo, required this.sharedPreferences});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _intentID = '';
  String get intentID => _intentID;

  bool _isPay = false;
  bool get isPay => _isPay;

  Future<bool> getIntentPaymentID(String orderID, BuildContext context) async {
    bool result = false;
    _isLoading = true;
    _intentID = '';
    notifyListeners();

    ApiResponse apiResponse = await payRepo.getPaymentIntentID(orderID);
    if (context.mounted) {
      result = ResponseHelper.responseHelper(context, apiResponse);
      if (result) {
        _intentID = apiResponse.response!.data['data']['Client_Secret'];
        notifyListeners();
      }
    }
    _isLoading = false;
    notifyListeners();
    return result;
  }

  // Bidding
  PaymentBiddingModel _paymentBiddingModel = PaymentBiddingModel();
  PaymentBiddingModel get paymentBiddingModel => _paymentBiddingModel;
  Payment _payment = Payment();
  Payment get payment => _payment;

  Future<bool> getBiddingIntentID(
      String biddingID, double amount, BuildContext context) async {
    bool result = false;
    _isLoading = true;
    _intentID = '';
    notifyListeners();

    ApiResponse apiResponse =
        await payRepo.getBiddingPaymentIntentID(biddingID, amount);
    if (context.mounted) {
      result = ResponseHelper.responseHelper(context, apiResponse);
      if (result) {
        _paymentBiddingModel =
            PaymentBiddingModel.fromJson(apiResponse.response!.data);
        _payment = _paymentBiddingModel.data!.payment!;
        notifyListeners();
      }
    }
    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<bool> makePayment(String id, BuildContext context, bool isBid) async {
    bool result = false;
    _isPay = true;
    notifyListeners();

    try {
      PaymentIntent response = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: id,
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(),
          ),
        ),
      );
      Map<String, dynamic> responseStatus = response.toJson();
      if (responseStatus['status'] == 'Succeeded') {
        if (!isBid) {
          ApiResponse apiResponse =
              await payRepo.handleSuccessPayment(_intentID);
          if (context.mounted) {
            result = ResponseHelper.responseHelper(context, apiResponse);
          }
        } else {
          ApiResponse apiResponse =
              await payRepo.handleBiddingPayment(payment.clientSecret!);
          if (context.mounted) {
            result = ResponseHelper.responseHelper(context, apiResponse);
          }
        }
      }
    } catch (e) {
      showCustomSnackBar(e.toString(), context);
    }

    _isPay = false;
    notifyListeners();
    return result;
  }
}
