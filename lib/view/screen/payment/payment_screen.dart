import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:nurserygardenapp/providers/pay_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/view/base/custom_button.dart';
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
  CardFieldInputDetails? _card = CardFieldInputDetails(complete: false);
  final controller = CardFormEditController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      return _getClientToken();
    });
  }

  void _getClientToken() async {
    await pay_prov.getIntentPaymentID(widget.orderID, context);
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
              ? Consumer<PayProvider>(builder: (context, payProvider, child) {
                  return payProvider.isLoading
                      ? Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            CardFormField(
                                style: CardFormStyle(
                                    backgroundColor: Colors.white,
                                    cursorColor: ColorResources.COLOR_PRIMARY,
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
                                  onTap: () async {
                                    await pay_prov.makePayment(
                                        pay_prov.intentID, context);
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
