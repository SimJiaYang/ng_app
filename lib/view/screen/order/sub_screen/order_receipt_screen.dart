import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nurserygardenapp/providers/delivery_provider.dart';
import 'package:nurserygardenapp/providers/order_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
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
    var theme = Theme.of(context).textTheme;
    TextStyle _title = theme.headlineMedium!.copyWith(
      fontSize: Dimensions.FONT_SIZE_DEFAULT,
      color: ColorResources.COLOR_BLACK.withOpacity(0.85),
    );
    TextStyle _subTitle = theme.headlineMedium!.copyWith(
      fontSize: Dimensions.FONT_SIZE_SMALL,
      fontWeight: FontWeight.w300,
      color: ColorResources.COLOR_BLACK.withOpacity(0.65),
    );

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
                  ? Loading()
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
                                  style: _title.copyWith(fontSize: 16)),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text("Order ID: ", style: _title),
                                  Text(
                                      orderProvider.orderReceiptInfo.id == null
                                          ? ""
                                          : orderProvider.orderReceiptInfo.id
                                              .toString(),
                                      style: _subTitle),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text("Order Time: ", style: _title),
                                  Text(
                                      DateFormat('dd-MM-yyyy').format(
                                          orderProvider
                                                  .orderReceiptInfo.createdAt ??
                                              DateTime.now()),
                                      style: _subTitle),
                                ],
                              ),
                              Divider(),
                              Text("Sender Information",
                                  style: _title.copyWith(fontSize: 16)),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text("Sender: ", style: _title),
                                  Text(orderProvider.receiptSender.sender ?? "",
                                      style: _subTitle),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Address: ", style: _title),
                                  Flexible(
                                    child: Text(
                                        orderProvider.receiptSender.address ??
                                            "",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 4,
                                        style: _subTitle),
                                  ),
                                ],
                              ),
                              Divider(),
                              Text("Receiver Information",
                                  style: _title.copyWith(fontSize: 16)),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text("Receiver: ", style: _title),
                                  Text(orderProvider.receiptUser.name ?? "",
                                      style: _subTitle),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Address: ", style: _title),
                                  Flexible(
                                    child: Text(
                                        orderProvider
                                                .orderReceiptInfo.address ??
                                            "",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 4,
                                        style: _subTitle),
                                  ),
                                ],
                              ),
                              Divider(),
                              const SizedBox(
                                height: 10,
                              ),
                              // Divider(),
                              Text("Order Summary",
                                  style: _title.copyWith(fontSize: 16)),
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
                                            style: _title,
                                          ),
                                          Text(
                                              orderProvider
                                                      .orderReceiptItem[index]
                                                      .plantName ??
                                                  orderProvider
                                                      .orderReceiptItem[index]
                                                      .productName ??
                                                  "",
                                              style: _title),
                                          Text(
                                              " x " +
                                                  orderProvider
                                                      .orderReceiptItem[index]
                                                      .quantity
                                                      .toString(),
                                              style: _subTitle),
                                          Spacer(),
                                          Text(
                                              " RM " +
                                                  orderProvider
                                                      .orderReceiptItem[index]
                                                      .amount!
                                                      .toStringAsFixed(2),
                                              style: _subTitle.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black)),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                    ],
                                  );
                                },
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total amount: ",
                                    style: _title,
                                  ),
                                  Text(
                                      "RM " +
                                          orderProvider
                                              .orderReceiptInfo.totalAmount!
                                              .toStringAsFixed(2),
                                      style: _subTitle.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black))
                                ],
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Text("Thank you for purchase at ",
                                      style: _subTitle),
                                  Text("Nursery Garden", style: _title),
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
