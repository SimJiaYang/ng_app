import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nurserygardenapp/data/model/order_model.dart';
import 'package:nurserygardenapp/providers/order_provider.dart';
import 'package:nurserygardenapp/util/app_constants.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/custom_text_style.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/base/custom_button.dart';
import 'package:nurserygardenapp/view/base/custom_dialog.dart';
import 'package:nurserygardenapp/view/screen/order/widget/empty_order_detail.dart';
import 'package:nurserygardenapp/view/screen/order/widget/shipping_status.dart';
import 'package:nurserygardenapp/view/screen/payment/payment_helper/payment_type.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderID;

  const OrderDetailScreen({required this.orderID, super.key});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late OrderProvider order_prov =
      Provider.of<OrderProvider>(context, listen: false);

  Order order = Order();
  String address = "";

  // Param
  var params = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      params['id'] = widget.orderID;
      _loadData();
    });
  }

  Future<void> _loadData() async {
    setState(() {
      order = order_prov.orderList
              .where((element) => element.id.toString() == widget.orderID)
              .firstOrNull ??
          Order();
      address = order.address ?? "";
    });
    await order_prov.getOrderDetail(context, params);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              order_prov.clearOrderDetail();
              Navigator.pop(context);
            }, // <-- SEE HERE
          ),
          backgroundColor: ColorResources.COLOR_PRIMARY,
          title: Text(
            "Order Detail",
            style: CustomTextStyles(context).titleStyle.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
          ),
          actions: [
            if (order.status == "completed")
              IconButton(
                tooltip: "Order Receipt",
                onPressed: () {
                  Navigator.pushNamed(
                      context, Routes.getOrderReceiptRoute(widget.orderID));
                },
                icon: Icon(Icons.receipt_long_outlined),
                color: Colors.white,
              )
          ],
        ),
        body: Container(
            width: size.width,
            child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Consumer<OrderProvider>(
                  builder: (context, orderProvider, child) {
                    return orderProvider.isLoadingDetail
                        ? EmptyOrderDetail()
                        : Container(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ShippingStatus(
                                    orderID: widget.orderID,
                                    status: order.status ?? ""),
                                Container(
                                  color: Colors.white,
                                  child: Divider(
                                    color: ColorResources.COLOR_GREY
                                        .withOpacity(0.1),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (order.status == "ship") {
                                      Navigator.pushNamed(context,
                                          Routes.getOrderAddressRoute(),
                                          arguments: {
                                            "orderID": widget.orderID,
                                            "address": address,
                                          }).then((value) {});
                                    } else {
                                      return;
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    color: Colors.white,
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Delivery address",
                                          style: CustomTextStyles(context)
                                              .titleStyle
                                              .copyWith(fontSize: 16),
                                        ),
                                        Text(
                                          address,
                                          style: CustomTextStyles(context)
                                              .subTitleStyle,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        if (order.status == "ship")
                                          Text(
                                            "Tap to change address",
                                            style: CustomTextStyles(context)
                                                .subTitleStyle
                                                .copyWith(
                                                    fontSize: 12,
                                                    color: ColorResources
                                                        .COLOR_PRIMARY),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: orderProvider.orderDetailList.length <
                                          2
                                      ? MediaQuery.of(context).size.height / 5
                                      : orderProvider.orderDetailList.length ==
                                              3
                                          ? MediaQuery.of(context).size.height /
                                              2.5
                                          : MediaQuery.of(context).size.height /
                                              2.5,
                                  child: ListView.builder(
                                      padding: (orderProvider.isLoadingDetail ||
                                              (orderProvider
                                                      .orderDetailList.length <
                                                  8))
                                          ? EdgeInsets.fromLTRB(10, 0, 10, 10)
                                          : EdgeInsets.only(
                                              bottom: 235,
                                              left: 10,
                                              right: 10,
                                              top: 0),
                                      shrinkWrap: true,
                                      itemCount:
                                          orderProvider.orderDetailList.length +
                                              (orderProvider.isLoading &&
                                                      orderProvider
                                                              .orderDetailList
                                                              .length >=
                                                          8
                                                  ? 1
                                                  : 0),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5),
                                                child: GestureDetector(
                                                  onTap: () {},
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      boxShadow: <BoxShadow>[
                                                        BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.2),
                                                            offset:
                                                                const Offset(
                                                                    0, 2),
                                                            blurRadius: 10.0),
                                                      ],
                                                    ),
                                                    child: Container(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        height: 120,
                                                        width: double.infinity,
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            if (orderProvider
                                                                    .orderDetailList[
                                                                        index]
                                                                    .remark !=
                                                                null)
                                                              Icon(
                                                                Icons.done,
                                                                color: ColorResources
                                                                    .COLOR_PRIMARY,
                                                              ),
                                                            if (orderProvider
                                                                        .orderDetailList[
                                                                            index]
                                                                        .remark ==
                                                                    null &&
                                                                (order
                                                                            .status ==
                                                                        "partial" ||
                                                                    order.status ==
                                                                        "recieve" ||
                                                                    order.status ==
                                                                        "completed"))
                                                              Icon(
                                                                Icons
                                                                    .more_horiz_outlined,
                                                                color: ColorResources
                                                                    .COLOR_GREY,
                                                              ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            if (orderProvider
                                                                    .orderDetailList[
                                                                        index]
                                                                    .plantId !=
                                                                null)
                                                              Container(
                                                                height: 80,
                                                                width: 80,
                                                                child:
                                                                    CachedNetworkImage(
                                                                  filterQuality:
                                                                      FilterQuality
                                                                          .high,
                                                                  imageUrl:
                                                                      "${orderProvider.getOrderPlantList.where((element) {
                                                                            return element.id ==
                                                                                orderProvider.orderDetailList[index].plantId;
                                                                          }).first.imageURL!}",
                                                                  memCacheHeight:
                                                                      200,
                                                                  memCacheWidth:
                                                                      200,
                                                                  imageBuilder:
                                                                      (context,
                                                                              imageProvider) =>
                                                                          Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      image:
                                                                          DecorationImage(
                                                                        image:
                                                                            imageProvider,
                                                                        fit: BoxFit
                                                                            .fitHeight,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  placeholder:
                                                                      (context,
                                                                              url) =>
                                                                          Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            1.0),
                                                                    child: Center(
                                                                        child: CircularProgressIndicator(
                                                                      color: ColorResources
                                                                          .COLOR_GRAY,
                                                                    )),
                                                                  ),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      Icon(Icons
                                                                          .error),
                                                                ),
                                                              ),
                                                            if (orderProvider
                                                                    .orderDetailList[
                                                                        index]
                                                                    .productId !=
                                                                null)
                                                              Container(
                                                                height: 80,
                                                                width: 80,
                                                                child:
                                                                    CachedNetworkImage(
                                                                  filterQuality:
                                                                      FilterQuality
                                                                          .high,
                                                                  imageUrl:
                                                                      "${"${orderProvider.getOrderProductList.where((element) {
                                                                            return element.id ==
                                                                                orderProvider.orderDetailList[index].productId;
                                                                          }).first.imageURL!}"}",
                                                                  memCacheHeight:
                                                                      200,
                                                                  memCacheWidth:
                                                                      200,
                                                                  imageBuilder:
                                                                      (context,
                                                                              imageProvider) =>
                                                                          Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      image:
                                                                          DecorationImage(
                                                                        image:
                                                                            imageProvider,
                                                                        fit: BoxFit
                                                                            .fitHeight,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  placeholder:
                                                                      (context,
                                                                              url) =>
                                                                          Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            1.0),
                                                                    child: Center(
                                                                        child: CircularProgressIndicator(
                                                                      color: ColorResources
                                                                          .COLOR_GRAY,
                                                                    )),
                                                                  ),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      Icon(Icons
                                                                          .error),
                                                                ),
                                                              ),
                                                            SizedBox(
                                                              width: 15,
                                                            ),
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      if (orderProvider
                                                                              .orderDetailList[index]
                                                                              .plantId !=
                                                                          null)
                                                                        Flexible(
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                100,
                                                                            child:
                                                                                Text(
                                                                              "${orderProvider.getOrderPlantList.where((element) {
                                                                                    return element.id == orderProvider.orderDetailList[index].plantId;
                                                                                  }).first.name}",
                                                                              style: CustomTextStyles(context).titleStyle.copyWith(fontSize: 16),
                                                                              softWrap: true,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      if (orderProvider
                                                                              .orderDetailList[index]
                                                                              .productId !=
                                                                          null)
                                                                        Flexible(
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                100,
                                                                            child:
                                                                                Text(
                                                                              "${orderProvider.getOrderProductList.where((element) {
                                                                                    return element.id == orderProvider.orderDetailList[index].productId;
                                                                                  }).first.name}",
                                                                              style: CustomTextStyles(context).titleStyle.copyWith(fontSize: 16),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      SizedBox(
                                                                        height:
                                                                            4,
                                                                      ),
                                                                      Text(
                                                                          "Quantity: ${orderProvider.orderDetailList[index].quantity}",
                                                                          style:
                                                                              TextStyle(fontSize: 14)),
                                                                      SizedBox(
                                                                        height:
                                                                            4,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Expanded(
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Text(
                                                                            "RM" +
                                                                                "${orderProvider.orderDetailList[index].amount!.toStringAsFixed(2)}",
                                                                            style:
                                                                                TextStyle(color: ColorResources.COLOR_PRIMARY, fontSize: 16))
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        )),
                                                  ),
                                                ),
                                              ),
                                            ]);
                                      }),
                                ),
                                Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Order Total",
                                            style: CustomTextStyles(context)
                                                .titleStyle
                                                .copyWith(fontSize: 16),
                                          ),
                                          Text(
                                            "RM" +
                                                "${order.totalAmount == null ? "" : order.totalAmount!.toStringAsFixed(2)}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: ColorResources
                                                    .COLOR_PRIMARY),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Order ID",
                                            style: CustomTextStyles(context)
                                                .titleStyle
                                                .copyWith(
                                                  fontSize: 16,
                                                ),
                                          ),
                                          Text(
                                            "${order.id}",
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Order Time",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: ColorResources.COLOR_GREY
                                                    .withOpacity(0.9),
                                                fontWeight: FontWeight.normal),
                                          ),
                                          Text(
                                            "${DateFormat('dd-MM-yyyy HH:mm').format(order.createdAt ?? DateTime.now())}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: ColorResources.COLOR_GREY
                                                    .withOpacity(0.9)),
                                          )
                                        ],
                                      ),
                                      if (order.note != null)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Order Remark",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: ColorResources
                                                      .COLOR_GREY
                                                      .withOpacity(0.9),
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            Text(
                                              order.note ?? "",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: ColorResources
                                                      .COLOR_GREY
                                                      .withOpacity(1.0)),
                                            )
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                if (order.status == "pay")
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: CustomButton(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context,
                                            Routes.getPaymentRoute(
                                                PaymentType.card.toString(),
                                                order.id.toString()));
                                      },
                                      btnTxt: "Pay Now",
                                    ),
                                  ),
                                if (order.status == "pay")
                                  Consumer<OrderProvider>(builder:
                                      (context, order_provider, child) {
                                    return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: CustomButton(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return CustomDialog(
                                                      dialogType: AppConstants
                                                          .DIALOG_CONFIRMATION,
                                                      btnText: "Yes",
                                                      btnTextCancel: "No",
                                                      title: "Cancel",
                                                      content:
                                                          "Are you sure you want to cancel this order?",
                                                      onPressed: () async {
                                                        if (order_provider
                                                            .isLoading) {
                                                          return;
                                                        } else {
                                                          await order_provider
                                                              .cancelOrder(
                                                                  context,
                                                                  order)
                                                              .then((value) {
                                                            if (value == true) {
                                                              Navigator.popUntil(
                                                                  context,
                                                                  ModalRoute
                                                                      .withName(
                                                                          Routes
                                                                              .getOrderRoute()));
                                                            }
                                                          });
                                                        }
                                                      });
                                                });
                                          },
                                          btnTxt: "Cancel Order",
                                          backgroundColor: Colors.red,
                                        ));
                                  }),
                                if (order.status == "receive" ||
                                    order.status == "partial")
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: CustomButton(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return CustomDialog(
                                                    dialogType: AppConstants
                                                        .DIALOG_CONFIRMATION,
                                                    btnText: "Yes",
                                                    btnTextCancel: "No",
                                                    title: "Receive",
                                                    content:
                                                        "Are you sure you have received this order?",
                                                    onPressed: () async {
                                                      if (orderProvider
                                                          .isLoading) {
                                                        return;
                                                      } else {
                                                        await orderProvider
                                                            .receiveOrder(
                                                          context,
                                                          order.id.toString(),
                                                        )
                                                            .then((value) {
                                                          if (value == true) {
                                                            Navigator.popUntil(
                                                                context,
                                                                ModalRoute.withName(
                                                                    Routes
                                                                        .getOrderRoute()));
                                                          }
                                                        });
                                                      }
                                                    });
                                              });
                                        },
                                        backgroundColor:
                                            ColorResources.COLOR_PRIMARY,
                                        btnTxt: "Order Received",
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          );
                  },
                ))));
  }
}
