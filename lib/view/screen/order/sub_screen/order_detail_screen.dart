import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nurserygardenapp/providers/order_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/base/custom_button.dart';
import 'package:nurserygardenapp/view/screen/order/widget/empty_order_detail.dart';
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
    await order_prov.getOrderDetail(context, params);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.white, // <-- SEE HERE
          ),
          backgroundColor: ColorResources.COLOR_PRIMARY,
          title: Text(
            "Order Detail",
            style: theme.bodyLarge!.copyWith(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        body: Container(
            width: size.width,
            child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Consumer<OrderProvider>(
                  builder: (context, orderProvider, child) {
                    return orderProvider.isLoadingDetail
                        ? EmptyOrderDetail()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                color: Colors.white,
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Shipping Information",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      "Shipping Status",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(
                                      height: 25,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                child: Divider(
                                  color: ColorResources.COLOR_GREY
                                      .withOpacity(0.1),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                color: Colors.white,
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Delivery address",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      orderProvider.orderList
                                          .where((element) {
                                            return element.id.toString() ==
                                                widget.orderID;
                                          })
                                          .first
                                          .address!,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(
                                      height: 25,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: orderProvider.orderDetailList.length < 2
                                    ? MediaQuery.of(context).size.height / 5
                                    : orderProvider.orderDetailList.length == 3
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
                                                              .withOpacity(0.2),
                                                          offset: const Offset(
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
                                                            width: 15,
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
                                                                      child:
                                                                          CircularProgressIndicator(
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
                                                                      child:
                                                                          CircularProgressIndicator(
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
                                                                      Text(
                                                                        "${orderProvider.getOrderPlantList.where((element) {
                                                                                          return element.id == orderProvider.orderDetailList[index].plantId;
                                                                                        }).first.name}"
                                                                                    .length >
                                                                                10
                                                                            ? "${orderProvider.getOrderPlantList.where((element) {
                                                                                  return element.id == orderProvider.orderDetailList[index].plantId;
                                                                                }).first.name!.substring(0, 10)}"
                                                                            : "${orderProvider.getOrderPlantList.where((element) {
                                                                                  return element.id == orderProvider.orderDetailList[index].plantId;
                                                                                }).first.name}",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16),
                                                                      ),
                                                                    if (orderProvider
                                                                            .orderDetailList[index]
                                                                            .productId !=
                                                                        null)
                                                                      Text(
                                                                        "${orderProvider.getOrderProductList.where((element) {
                                                                                          return element.id == orderProvider.orderDetailList[index].productId;
                                                                                        }).first.name}"
                                                                                    .length >
                                                                                10
                                                                            ? "${orderProvider.getOrderProductList.where((element) {
                                                                                  return element.id == orderProvider.orderDetailList[index].productId;
                                                                                }).first.name!.substring(0, 10)}"
                                                                            : "${orderProvider.getOrderProductList.where((element) {
                                                                                  return element.id == orderProvider.orderDetailList[index].productId;
                                                                                }).first.name}",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16),
                                                                      ),
                                                                    SizedBox(
                                                                      height: 4,
                                                                    ),
                                                                    Text(
                                                                        "Quantity: ${orderProvider.orderDetailList[index].quantity}",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14)),
                                                                    SizedBox(
                                                                      height: 4,
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
                                                                          style: TextStyle(
                                                                              color: ColorResources.COLOR_PRIMARY,
                                                                              fontSize: 16))
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Order Total",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          "RM" +
                                              "${orderProvider.orderList.where((element) {
                                                    return element.id
                                                            .toString() ==
                                                        widget.orderID;
                                                  }).first.totalAmount!.toStringAsFixed(2)}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color:
                                                  ColorResources.COLOR_PRIMARY),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Order ID",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${orderProvider.orderList.where((element) {
                                                return element.id.toString() ==
                                                    widget.orderID;
                                              }).first.id}",
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
                                          "${DateFormat('dd-MM-yyyy HH:mm').format(orderProvider.orderList.where((element) {
                                                return element.id.toString() ==
                                                    widget.orderID;
                                              }).first.createdAt!)}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: ColorResources.COLOR_GREY
                                                  .withOpacity(0.9)),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              if (orderProvider.orderList
                                      .where((element) {
                                        return element.id.toString() ==
                                            widget.orderID;
                                      })
                                      .first
                                      .status ==
                                  "pay")
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: CustomButton(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context,
                                          Routes.getPaymentRoute(
                                              PaymentType.card.toString(),
                                              orderProvider.orderList
                                                  .where((element) {
                                                    return element.id
                                                            .toString() ==
                                                        widget.orderID;
                                                  })
                                                  .first
                                                  .id
                                                  .toString()));
                                    },
                                    btnTxt: "Pay Now",
                                  ),
                                )
                            ],
                          );
                  },
                ))));
  }
}
