import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/images.dart';
import 'package:nurserygardenapp/view/base/custom_button.dart';
import 'package:nurserygardenapp/view/base/custom_textfield.dart';
import 'package:nurserygardenapp/view/screen/payment/payment_helper/card_input_formatter.dart';
import 'package:nurserygardenapp/view/screen/payment/payment_helper/card_type.dart';
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
  GlobalKey<FormState>? _formKey = GlobalKey<FormState>();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();

  CardType cardType = CardType.Others;

  @override
  void dispose() {
    cardNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    cardNumberController.addListener(
      () {
        getCardTypeFrmNumber();
      },
    );

    super.initState();
  }

  // void showPaymentForm() async {
  //   await Stripe.instance
  //       .initPaymentSheet(
  //     paymentSheetParameters: SetupPaymentSheetParameters(
  //       billingDetails: BillingDetails(
  //           name: 'YOUR NAME',
  //           email: 'YOUREMAIL@gmail.com',
  //           phone: 'YOUR NUMBER',
  //           address: Address(
  //               city: 'YOUR CITY',
  //               country: 'YOUR COUNTRY',
  //               line1: 'YOUR ADDRESS 1',
  //               line2: 'YOUR ADDRESS 2',
  //               postalCode: 'YOUR PINCODE',
  //               state: 'YOUR STATE')),
  //       paymentIntentClientSecret:
  //           'pi_3O6s0kAEge1njPEk1FQIREMW_secret_BbCbapjIdCow4vNPykLwhsZZ3', //Gotten from payment intent
  //       style: ThemeMode.dark,
  //       merchantDisplayName: 'Nursery Garden',
  //     ),
  //   )
  //       .then((value) async {
  //     displayPaymentSheet();
  //   });
  //   setState(() {
  //     isInitialized = false;
  //   });
  // }

  // displayPaymentSheet() async {
  //   try {
  //     final paymentSheetResult = await Stripe.instance.presentPaymentSheet();
  //     Fluttertoast.showToast(msg: 'Payment succesfully completed');
  //   } on Exception catch (e) {
  //     if (e is StripeException) {
  //       showCustomSnackBar('${e.error.localizedMessage}', context);
  //     } else {
  //       showCustomSnackBar('Unforeseen error', context);
  //     }
  //   }
  // }

  void getCardTypeFrmNumber() {
    if (cardNumberController.text.length <= 6) {
      String input = CardUtils.getCleanedNumber(cardNumberController.text);
      CardType type = CardUtils.getCardTypeFrmNumber(input);
      if (type != cardType) {
        setState(() {
          cardType = type;
        });
      }
    }
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
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            isShowPrefixIcon: true,
                            isShowSuffixIcon: true,
                            SuffixIconWidget: CardUtils.getCardIcon(cardType),
                            prefixIconUrl: Icon(Icons.credit_card_outlined,
                                color: ColorResources.COLOR_GREY_CHATEAU),
                            controller: cardNumberController,
                            inputType: TextInputType.number,
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(16),
                              CardNumberInputFormatter(),
                            ],
                            isApplyValidator: true,
                            validator: (value) {
                              return CardUtils.validateCardNum(value);
                            },
                            hintText: "Card number",
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: CustomTextField(
                              isShowPrefixIcon: true,
                              prefixIconUrl: Icon(Icons.person_2_outlined,
                                  color: ColorResources.COLOR_GREY_CHATEAU),
                              controller: cardHolderNameController,
                              hintText: "Full name",
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  isShowPrefixIcon: true,
                                  prefixIconUrl: Container(
                                      height: 20,
                                      width: 20,
                                      child: Image.asset(Images.cvv)),
                                  controller: cvvController,
                                  inputType: TextInputType.number,
                                  inputFormatter: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                  hintText: "CVV",
                                  isApplyValidator: true,
                                  validator: (value) {
                                    return CardUtils.validateCVV(value);
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CustomTextField(
                                  isShowPrefixIcon: true,
                                  prefixIconUrl: Icon(
                                      Icons.calendar_month_outlined,
                                      color: ColorResources.COLOR_GREY_CHATEAU),
                                  controller: expiryDateController,
                                  inputType: TextInputType.number,
                                  inputFormatter: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                    CardMonthInputFormatter(),
                                  ],
                                  isApplyValidator: true,
                                  validator: (value) {
                                    return CardUtils.validateDate(value);
                                  },
                                  hintText: "MM/YY",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: CustomButton(
                          btnTxt: "Proceed",
                          onTap: () {
                            bool validate = _formKey!.currentState!.validate();
                            if (validate) {
                              print(cardHolderNameController.text);
                              print(cardNumberController.text);
                              print(expiryDateController.text);
                              print(cvvController.text);
                            }
                          },
                        )),
                    const Spacer(),
                  ],
                )
              : Container(
                  child: Center(
                  child: Text("Comming Soon"),
                ))),
    );
  }
}
