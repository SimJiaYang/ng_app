import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nurserygardenapp/providers/order_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late OrderProvider order_prov =
      Provider.of<OrderProvider>(context, listen: false);
  final _scrollController = ScrollController();
  String _selectedStatus = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (order_prov.orderList.length < int.parse(params['limit']!)) return;
      int currentLimit = int.parse(params['limit']!);
      currentLimit += 8;
      params['limit'] = currentLimit.toString();
      _loadData(isLoadMore: true);
    }
  }

  // Param
  var params = {
    'limit': '8',
  };

  Future<void> _loadData({bool isLoadMore = false}) async {
    await order_prov.getOrderList(context, params, isLoadMore: isLoadMore);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.white, // <-- SEE HERE
          ),
          backgroundColor: ColorResources.COLOR_PRIMARY,
          title: Text(
            "Orders",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 18,
            ),
          ),
        ),
        body: Container(
            padding: EdgeInsets.only(top: 5),
            width: size.width,
            child: Column(
              children: [
                Consumer<OrderProvider>(
                  builder: (context, orderProvider, child) {
                    return orderProvider.orderList.isEmpty &&
                            orderProvider.isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : orderProvider.orderList.isEmpty &&
                                !orderProvider.isLoading
                            ? Center(
                                child: Text(
                                "No Orders",
                                style: TextStyle(
                                    color: Colors.grey.withOpacity(0.7),
                                    fontSize: 18),
                              ))
                            : ListView.builder(
                                padding: (orderProvider
                                                .noMoreDataMessage.isNotEmpty &&
                                            !orderProvider.isLoading ||
                                        (orderProvider
                                                .noMoreDataMessage.isEmpty &&
                                            orderProvider.orderList.length < 8))
                                    ? EdgeInsets.fromLTRB(10, 0, 10, 10)
                                    : EdgeInsets.only(
                                        bottom: 235,
                                        left: 10,
                                        right: 10,
                                        top: 0),
                                controller: _scrollController,
                                physics: const BouncingScrollPhysics(),
                                itemCount: orderProvider.orderList.length +
                                    (orderProvider.isLoading &&
                                            orderProvider.orderList.length >= 8
                                        ? 1
                                        : 0),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  if (index >= orderProvider.orderList.length &&
                                      orderProvider.noMoreDataMessage.isEmpty) {
                                    return CircularProgressIndicator();
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 10, 10, 5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                offset: const Offset(0, 2),
                                                blurRadius: 10.0),
                                          ],
                                        ),
                                        height: 150,
                                        width: double.infinity,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Order ID: " +
                                                          orderProvider
                                                              .orderList[index]
                                                              .id
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    Text(
                                                      'Order Status',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: ColorResources
                                                              .COLOR_PRIMARY,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ]),
                                              Spacer(),
                                              Text(
                                                'Order created at: ' +
                                                    DateFormat('dd-MM-yyyy')
                                                        .format(orderProvider
                                                            .orderList[index]
                                                            .date!),
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Order Total: ",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  Text(
                                                    "RM" +
                                                        orderProvider
                                                            .orderList[index]
                                                            .totalAmount
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: ColorResources
                                                            .COLOR_PRIMARY,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              Container(
                                                height: 35,
                                                width: double.infinity,
                                                child: Text(
                                                  "Delivery Status",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: ColorResources
                                                          .COLOR_PRIMARY,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              )
                                            ]),
                                      ),
                                    );
                                  }
                                });
                  },
                ),
              ],
            )));
  }
}
