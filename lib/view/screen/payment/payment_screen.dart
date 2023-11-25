import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:nurserygardenapp/providers/pay_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/base/custom_button.dart';
import 'package:nurserygardenapp/view/base/custom_snackbar.dart';
import 'package:nurserygardenapp/view/base/page_loading.dart';
import 'package:nurserygardenapp/view/screen/payment/payment_helper/payment_type.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  final String paymentType;
  final String orderID;
  const PaymentScreen(
      {super.key, required this.paymentType, required this.orderID});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late PayProvider pay_prov = Provider.of<PayProvider>(context, listen: false);
  // Cannot delete
  CardFieldInputDetails? _card = CardFieldInputDetails(complete: false);
  final cardFormontroller = CardFormEditController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      return _getClientToken();
    });
  }

  void _getClientToken() async {
    await pay_prov.getIntentPaymentID(widget.orderID, context);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: ColorResources.COLOR_PRIMARY,
          leading: BackButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
            },
            color: Colors.white, // <-- SEE HERE
          ),
          title: Text(
            "Payment",
            style: theme.bodyLarge!.copyWith(
              color: Colors.white,
              fontSize: 16,
            ),
          )),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(16),
          child: widget.paymentType == PaymentType.card.toString()
              ? Consumer<PayProvider>(builder: (context, payProvider, child) {
                  return payProvider.isLoading
                      ? LoadingThreeCircle()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text("Debit/Credit Card Payment"),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Container(
                                height: size.height * 0.25,
                                child: CardFormField(
                                    style: CardFormStyle(
                                      backgroundColor: Colors.white,
                                      borderWidth: 1,
                                      borderColor: Colors.grey,
                                      borderRadius: 8,
                                      cursorColor: ColorResources.COLOR_PRIMARY,
                                      textColor: Colors.black,
                                      fontSize: 16,
                                      textErrorColor: Colors.red,
                                      placeholderColor: Colors.grey,
                                    ),
                                    enablePostalCode: false,
                                    countryCode: "MY",
                                    controller: cardFormontroller,
                                    onCardChanged: (card) {
                                      setState(() {
                                        _card = card;
                                      });
                                    }),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 1),
                                child: CustomButton(
                                  btnTxt: "Proceed",
                                  onTap: () async {
                                    if (payProvider.isLoading) {
                                      return;
                                    }
                                    if (cardFormontroller.details.complete ==
                                        false) {
                                      showCustomSnackBar(
                                          "Please fill up the card", context);
                                    }
                                    if (cardFormontroller.details.complete ==
                                        true) {
                                      FocusScope.of(context).unfocus();
                                      EasyLoading.show(
                                        status: 'Please wait...',
                                      );
                                      await pay_prov
                                          .makePayment(
                                              pay_prov.intentID, context)
                                          .then((value) {
                                        EasyLoading.dismiss();
                                        if (value == true) {
                                          Navigator.pushReplacementNamed(
                                              context, Routes.getOrderRoute());
                                        }
                                      });
                                    }
                                  },
                                )),
                          ],
                        );
                })
              : Container(
                  child: Center(
                  child: Text("Comming Soon"),
                ))),
    );
  }
}
