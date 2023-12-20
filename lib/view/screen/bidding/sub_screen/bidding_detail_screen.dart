import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nurserygardenapp/data/model/bidding_model.dart';
import 'package:nurserygardenapp/providers/bidding_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/custom_text_style.dart';
import 'package:nurserygardenapp/util/dimensions.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/base/custom_button.dart';
import 'package:nurserygardenapp/view/base/custom_space.dart';
import 'package:nurserygardenapp/view/base/custom_textfield.dart';
import 'package:nurserygardenapp/view/base/image_enlarge_widget.dart';
import 'package:nurserygardenapp/view/base/page_loading.dart';
import 'package:nurserygardenapp/view/screen/bidding/widget/number_item.dart';
import 'package:nurserygardenapp/view/screen/payment/payment_helper/payment_type.dart';
import 'package:provider/provider.dart';

class BiddingDetailScreen extends StatefulWidget {
  final String biddingID;
  const BiddingDetailScreen({super.key, required this.biddingID});

  @override
  State<BiddingDetailScreen> createState() => _BiddingDetailScreenState();
}

class _BiddingDetailScreenState extends State<BiddingDetailScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late BiddingProvider biddingProvider =
      Provider.of<BiddingProvider>(context, listen: false);
  late Bidding bidding = Bidding();

  TextEditingController bidController = TextEditingController();
  FocusNode bidFocus = FocusNode();
  bool isLoading = true;
  late Timer fetchTimer;
  double highestAmount = 0;
  double minAmount = 0;
  String errorMessage = "";
  double userBidAmount = 0;

  @override
  void initState() {
    super.initState();
    fetchTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      updateHighestAmount();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      return _loadData();
    });
  }

  void updateHighestAmount() async {
    await biddingProvider.getBidDetail(context, widget.biddingID).then((value) {
      if (value == true) {
        setState(() {
          highestAmount = biddingProvider.bid.highestAmt!.toDouble();
          userBidAmount = biddingProvider.userBid.toDouble();
        });
      }
    });
  }

  _loadData() {
    bidding = biddingProvider.biddingList
        .where((element) => element.biddingId.toString() == widget.biddingID)
        .first;

    // Update highest amount && user bid amount at first
    updateHighestAmount();

    setState(() {
      isLoading = false;
      highestAmount = (bidding.highestAmt).toDouble() ?? 0;
      minAmount = (bidding.minAmt) == null ? 0 : (bidding.minAmt!).toDouble();
      bidController.text = (highestAmount + minAmount).toStringAsFixed(0);
    });
  }

  @override
  void dispose() {
    fetchTimer.cancel();
    bidController.dispose();
    bidFocus.dispose();
    super.dispose();
  }

  void resetErrorMsg() {
    setState(() {
      errorMessage = "";
    });
  }

  void showModalBottom(BuildContext context) {
    bidController.text = (highestAmount + minAmount).toStringAsFixed(0);
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    offset: const Offset(0, 2),
                    blurRadius: 10.0),
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.5,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 120,
                  padding: EdgeInsets.all(3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Place a Bid",
                        style: CustomTextStyles(context)
                            .titleStyle
                            .copyWith(color: ColorResources.COLOR_PRIMARY),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return Form(
                          key: _formKey,
                          child: CustomTextField(
                              inputType: TextInputType.number,
                              hintText: "Enter Amount",
                              isShowBorder: true,
                              isShowSuffixIcon: false,
                              isShowPrefixIcon: true,
                              prefixIconUrl: Text(
                                "RM" + " ",
                                style: CustomTextStyles(context)
                                    .titleStyle
                                    .copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE,
                                        color: ColorResources.COLOR_PRIMARY),
                              ),
                              controller: bidController,
                              focusNode: bidFocus,
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    errorMessage = "Cannot left empty field";
                                  });
                                } else if (double.tryParse(value)! <
                                    highestAmount) {
                                  setState(() {
                                    errorMessage =
                                        "Please enter amount higher than current bid";
                                  });
                                } else if (double.tryParse(value)! <
                                    highestAmount + minAmount) {
                                  setState(() {
                                    errorMessage =
                                        "Please enter amount higher than minimum bid for everytime";
                                  });
                                } else if (double.tryParse(value)! >= 100000) {
                                  setState(() {
                                    errorMessage =
                                        "Please enter amount lower than RM 100000.00";
                                  });
                                } else {
                                  setState(() {
                                    errorMessage = "";
                                  });
                                }
                              }),
                        );
                      }),
                      if (errorMessage.isNotEmpty)
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Container(
                              height: 100,
                              child: Text(errorMessage,
                                  style: CustomTextStyles(context)
                                      .titleStyle
                                      .copyWith(color: Colors.red)),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                    padding: const EdgeInsets.fromLTRB(3, 5, 3, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  bidController.text =
                                      (double.parse(bidController.text) + 20)
                                          .toStringAsFixed(0);
                                },
                                child: NumberItem(amount: "20")),
                            GestureDetector(
                                onTap: () {
                                  bidController.text =
                                      (double.parse(bidController.text) + 50)
                                          .toStringAsFixed(0);
                                },
                                child: NumberItem(amount: "50")),
                            GestureDetector(
                                onTap: () {
                                  bidController.text =
                                      (double.parse(bidController.text) + 100)
                                          .toStringAsFixed(0);
                                },
                                child: NumberItem(amount: "100")),
                          ],
                        ),
                        VerticalSpacing(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  bidController.text =
                                      (double.parse(bidController.text) + 200)
                                          .toStringAsFixed(0);
                                },
                                child: NumberItem(amount: "200")),
                            GestureDetector(
                                onTap: () {
                                  bidController.text =
                                      (double.parse(bidController.text) + 500)
                                          .toStringAsFixed(0);
                                },
                                child: NumberItem(amount: "500")),
                            GestureDetector(
                                onTap: () {
                                  bidController.text =
                                      (double.parse(bidController.text) + 1000)
                                          .toStringAsFixed(0);
                                },
                                child: NumberItem(amount: "1000")),
                          ],
                        ),
                      ],
                    )),
                Spacer(),
                Flexible(
                    child: Text(
                  "*Please note that if you are the winner of bidder, we will not be able to refund your money.",
                  style: CustomTextStyles(context).subTitleStyle.copyWith(
                      fontSize: Dimensions.FONT_SIZE_SMALL,
                      color: ColorResources.COLOR_GRAY),
                )),
                VerticalSpacing(
                  height: 3,
                ),
                CustomButton(
                  btnTxt: "Place Bid",
                  onTap: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    double amount = double.parse(bidController.text);
                    if (amount <= highestAmount) {
                      setState(() {
                        errorMessage =
                            "Please enter amount higher than current bid";
                      });
                      return;
                    } else if (amount < (minAmount + highestAmount)) {
                      setState(() {
                        errorMessage =
                            "Please enter amount higher than minimum bid for everytime";
                      });
                      return;
                    } else if (amount >= 100000) {
                      setState(() {
                        errorMessage =
                            "Please enter amount lower than RM 100000.00";
                      });
                      return;
                    } else {
                      setState(() {
                        errorMessage = "";
                      });
                      Navigator.pushNamed(
                          context,
                          Routes.getPaymentRoute(
                            PaymentType.card.toString(),
                            "0",
                          ),
                          arguments: {
                            "amount": amount,
                            "bidding_id": bidding.biddingId.toString()
                          });
                    }
                  },
                )
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.white, // <-- SEE HERE
          ),
          backgroundColor: ColorResources.COLOR_PRIMARY,
        ),
        bottomNavigationBar: BottomAppBar(
            height: 60,
            padding: EdgeInsets.all(0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey,
                      offset: const Offset(0, 2),
                      blurRadius: 10.0),
                ],
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          resetErrorMsg();
                          showModalBottom(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorResources.COLOR_PRIMARY,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              Text(
                                'Place a Bid',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
            )),
        body: SafeArea(
          child: isLoading
              ? LoadingThreeCircle()
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          color: ColorResources.COLOR_WHITE,
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return ImageEnlargeWidget(
                                  tag: "plant_${bidding.id}",
                                  url: "${bidding.image}",
                                );
                              }));
                            },
                            child: Hero(
                              tag: "plant_${bidding.id}",
                              child: CachedNetworkImage(
                                filterQuality: FilterQuality.high,
                                height: 300,
                                fit: BoxFit.fitHeight,
                                imageUrl: "${bidding.image}",
                                placeholder: (context, url) => Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Center(
                                      child: CircularProgressIndicator(
                                    color: ColorResources.COLOR_GRAY,
                                  )),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          color: ColorResources.COLOR_WHITE,
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("${bidding.name}",
                                      style: CustomTextStyles(context)
                                          .titleStyle
                                          .copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_LARGE)),
                                ],
                              ),
                              VerticalSpacing(
                                height: 10,
                              ),
                              Text(
                                  "Your Paid: RM ${userBidAmount.toStringAsFixed(2)}",
                                  style: CustomTextStyles(context)
                                      .titleStyle
                                      .copyWith(
                                          color: ColorResources
                                              .APPBAR_HEADER_COLOR)),
                              VerticalSpacing(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: ColorResources.COLOR_WHITE,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        offset: const Offset(0, 2),
                                        blurRadius: 15.0),
                                  ],
                                ),
                                child: Text(
                                    "Highest Bid: RM ${highestAmount.toStringAsFixed(2)}",
                                    style: CustomTextStyles(context)
                                        .titleStyle
                                        .copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_LARGE,
                                            color:
                                                ColorResources.COLOR_PRIMARY)),
                              ),
                              VerticalSpacing(
                                height: 10,
                              ),
                              Container(
                                child: Text(
                                    "Min for New Bid + RM ${minAmount.toStringAsFixed(2)}",
                                    style: CustomTextStyles(context)
                                        .titleStyle
                                        .copyWith(
                                            color:
                                                ColorResources.COLOR_PRIMARY)),
                              ),
                            ],
                          ),
                        ),
                        VerticalSpacing(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          color: ColorResources.COLOR_WHITE,
                          padding: EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Category:",
                                  style: CustomTextStyles(context).titleStyle),
                              HorizontalSpacing(
                                width: 3,
                              ),
                              Text("${bidding.categoryName}",
                                  style:
                                      CustomTextStyles(context).subTitleStyle),
                            ],
                          ),
                        ),
                        VerticalSpacing(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          color: ColorResources.COLOR_WHITE,
                          padding: EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Plant Origin:",
                                  style: CustomTextStyles(context).titleStyle),
                              HorizontalSpacing(
                                width: 3,
                              ),
                              Text("${bidding.origin}",
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      CustomTextStyles(context).subTitleStyle),
                              Expanded(child: Container()),
                              Text("Mature Height:",
                                  style: CustomTextStyles(context).titleStyle),
                              HorizontalSpacing(
                                width: 3,
                              ),
                              Text("${bidding.matureHeight} m",
                                  style:
                                      CustomTextStyles(context).subTitleStyle)
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          color: ColorResources.COLOR_WHITE,
                          padding: EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Sunlight Need:",
                                  style: CustomTextStyles(context).titleStyle),
                              HorizontalSpacing(
                                width: 3,
                              ),
                              Text("${bidding.sunlightNeed}",
                                  style:
                                      CustomTextStyles(context).subTitleStyle),
                              Expanded(child: Container()),
                              Text("Water Need:",
                                  style: CustomTextStyles(context).titleStyle),
                              HorizontalSpacing(
                                width: 3,
                              ),
                              Text("${bidding.waterNeed}",
                                  style:
                                      CustomTextStyles(context).subTitleStyle)
                            ],
                          ),
                        ),
                        VerticalSpacing(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          color: ColorResources.COLOR_WHITE,
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Description",
                                  style: CustomTextStyles(context).titleStyle),
                              VerticalSpacing(
                                height: 10,
                              ),
                              Text("${bidding.description}",
                                  textAlign: TextAlign.justify,
                                  style:
                                      CustomTextStyles(context).subTitleStyle),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ));
  }
}
