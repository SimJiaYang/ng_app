import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nurserygardenapp/providers/order_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/custom_text_style.dart';
import 'package:nurserygardenapp/util/dimensions.dart';
import 'package:nurserygardenapp/view/base/custom_appbar.dart';
import 'package:nurserygardenapp/view/base/page_loading.dart';
import 'package:provider/provider.dart';

class OrderReceiptScreen extends StatefulWidget {
  final String orderID;
  const OrderReceiptScreen({super.key, required this.orderID});

  @override
  State<OrderReceiptScreen> createState() => _OrderReceiptScreenState();
}

class _OrderReceiptScreenState extends State<OrderReceiptScreen> {
  late OrderProvider _orderProvider =
      Provider.of<OrderProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  _loadData() async {
    await _orderProvider.getOrderReceipt(context, {
      'id': widget.orderID,
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: CustomAppBar(
          isBgPrimaryColor: true,
          isCenter: false,
          isBackButtonExist: false,
          title: "Order Receipt",
          context: context,
        ),
        body: Container(
            color: ColorResources.COLOR_WHITE,
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
            height: size.height,
            width: size.width,
            child: Consumer<OrderProvider>(
                builder: (context, orderProvider, child) {
              // Change
              return orderProvider.isLoadingReceipt
                  ? LoadingThreeCircle()
                  : Container(
                      padding:
                          const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                      width: double.infinity,
                      height: size.height,
                      decoration: BoxDecoration(
                        color: ColorResources.COLOR_WHITE,
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(
                          color: ColorResources.COLOR_GREY.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Order Information",
                                  style: CustomTextStyles(context)
                                      .titleStyle
                                      .copyWith(fontSize: 16)),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text("Order ID: ",
                                      style:
                                          CustomTextStyles(context).titleStyle),
                                  Text(
                                      orderProvider.orderReceiptInfo.id == null
                                          ? ""
                                          : orderProvider.orderReceiptInfo.id
                                              .toString(),
                                      style: CustomTextStyles(context)
                                          .subTitleStyle),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text("Order Time: ",
                                      style:
                                          CustomTextStyles(context).titleStyle),
                                  Text(
                                      DateFormat('dd-MM-yyyy').format(
                                          orderProvider
                                                  .orderReceiptInfo.createdAt ??
                                              DateTime.now()),
                                      style: CustomTextStyles(context)
                                          .subTitleStyle),
                                ],
                              ),
                              Divider(),
                              Text("Sender Information",
                                  style: CustomTextStyles(context)
                                      .titleStyle
                                      .copyWith(fontSize: 16)),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text("Sender: ",
                                      style:
                                          CustomTextStyles(context).titleStyle),
                                  Text(orderProvider.receiptSender.sender ?? "",
                                      style: CustomTextStyles(context)
                                          .subTitleStyle),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Address: ",
                                      style:
                                          CustomTextStyles(context).titleStyle),
                                  Flexible(
                                    child: Text(
                                        orderProvider.receiptSender.address ??
                                            "",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 4,
                                        style: CustomTextStyles(context)
                                            .subTitleStyle),
                                  ),
                                ],
                              ),
                              Divider(),
                              Text("Receiver Information",
                                  style: CustomTextStyles(context)
                                      .titleStyle
                                      .copyWith(fontSize: 16)),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text("Receiver: ",
                                      style:
                                          CustomTextStyles(context).titleStyle),
                                  Text(orderProvider.receiptUser.name ?? "",
                                      style: CustomTextStyles(context)
                                          .subTitleStyle),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Address: ",
                                      style:
                                          CustomTextStyles(context).titleStyle),
                                  Flexible(
                                    child: Text(
                                        orderProvider
                                                .orderReceiptInfo.address ??
                                            "",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 4,
                                        style: CustomTextStyles(context)
                                            .subTitleStyle),
                                  ),
                                ],
                              ),
                              Divider(),
                              const SizedBox(
                                height: 10,
                              ),
                              // Divider(),
                              Text("Order Summary",
                                  style: CustomTextStyles(context)
                                      .titleStyle
                                      .copyWith(fontSize: 16)),
                              SizedBox(height: 5),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                    orderProvider.orderReceiptItem.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Row(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${(index + 1).toString()}. ",
                                            style: CustomTextStyles(context)
                                                .titleStyle,
                                          ),
                                          Text(
                                              orderProvider
                                                      .orderReceiptItem[index]
                                                      .plantName ??
                                                  orderProvider
                                                      .orderReceiptItem[index]
                                                      .productName ??
                                                  "",
                                              style: CustomTextStyles(context)
                                                  .titleStyle),
                                          Text(
                                              " x " +
                                                  orderProvider
                                                      .orderReceiptItem[index]
                                                      .quantity
                                                      .toString(),
                                              style: CustomTextStyles(context)
                                                  .subTitleStyle),
                                          Spacer(),
                                          if (orderProvider
                                                  .orderReceiptItem[index]
                                                  .amount !=
                                              null)
                                            Text(
                                                " RM " +
                                                    orderProvider
                                                        .orderReceiptItem[index]
                                                        .amount!
                                                        .toStringAsFixed(2),
                                                style: CustomTextStyles(context)
                                                    .subTitleStyle
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black)),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                    ],
                                  );
                                },
                              ),
                              Divider(),
                              if (orderProvider.orderReceiptInfo.totalAmount !=
                                  null)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total amount: ",
                                      style:
                                          CustomTextStyles(context).titleStyle,
                                    ),
                                    Text(
                                        "RM " +
                                            orderProvider
                                                .orderReceiptInfo.totalAmount!
                                                .toStringAsFixed(2),
                                        style: CustomTextStyles(context)
                                            .subTitleStyle
                                            .copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black))
                                  ],
                                ),
                              Divider(),
                              Row(
                                children: [
                                  Text("Thank you for purchase at ",
                                      style: CustomTextStyles(context)
                                          .subTitleStyle),
                                  Text("Nursery Garden",
                                      style:
                                          CustomTextStyles(context).titleStyle),
                                  Icon(
                                    Icons.favorite,
                                    color: ColorResources.COLOR_PRIMARY,
                                    size: 15,
                                  )
                                ],
                              ),
                            ],
                          )),
                    );
            })));
  }
}
