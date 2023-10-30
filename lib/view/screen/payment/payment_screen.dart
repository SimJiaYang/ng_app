import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/view/base/custom_button.dart';
import 'package:nurserygardenapp/view/screen/payment/payment_helper/payment_type.dart';

class PaymentScreen extends StatefulWidget {
  final String paymentType;
  final String orderID;
  const PaymentScreen(
      {super.key, required this.paymentType, required this.orderID});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  CardFieldInputDetails? _card = CardFieldInputDetails(complete: false);
  final controller = CardFormEditController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void _getClientToken() {
    confirmPayment();
  }

  void confirmPayment() async {
    var response = await Stripe.instance.confirmPayment(
      paymentIntentClientSecret:
          'pi_3O6xucAEge1njPEk1f1C4jsX_secret_ZyZ9woK7U77SOSwiRaO0tUZih',
      data: PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(
          billingDetails: BillingDetails(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: ColorResources.COLOR_PRIMARY,
          leading: const BackButton(
            color: Colors.white, // <-- SEE HERE
          ),
          title: Text(
            "Payment",
            style: TextStyle(
                fontWeight: FontWeight.w400, fontSize: 18, color: Colors.white),
          )),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(16),
          child: widget.paymentType == PaymentType.card.toString()
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    CardFormField(
                        style: CardFormStyle(
                            backgroundColor: Colors.white,
                            cursorColor: ColorResources.COLOR_PRIMARY,
                            // textColor:
                            //     ColorResources.COLOR_BLACK.withOpacity(0.8),
                            // borderRadius: 2,
                            // borderWidth: 1,
                            borderColor: ColorResources.COLOR_BLACK),
                        countryCode: "MY",
                        enablePostalCode: false,
                        controller: controller,
                        onCardChanged: (card) {
                          setState(() {
                            _card = card;
                          });
                        }),
                    Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: CustomButton(
                          btnTxt: "Proceed",
                          onTap: () {
                            setState(() {
                              _getClientToken();
                            });
                          },
                        )),
                  ],
                )
              : Container(
                  child: Center(
                  child: Text("Comming Soon"),
                ))),
    );
  }
}
