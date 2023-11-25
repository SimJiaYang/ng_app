import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nurserygardenapp/providers/delivery_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/dimensions.dart';
import 'package:nurserygardenapp/view/base/custom_appbar.dart';
import 'package:nurserygardenapp/view/base/page_loading.dart';
import 'package:provider/provider.dart';

class DeliveryReceiptScreen extends StatefulWidget {
  final String deliveryID;
  const DeliveryReceiptScreen({super.key, required this.deliveryID});

  @override
  State<DeliveryReceiptScreen> createState() => _DeliveryReceiptScreenState();
}

class _DeliveryReceiptScreenState extends State<DeliveryReceiptScreen> {
  late DeliveryProvider _deliveryProvider =
      Provider.of<DeliveryProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  _loadData() async {
    await _deliveryProvider.getDeliveryReceipt(context, {
      'id': widget.deliveryID,
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
          title: "Delivery Detail",
          context: context,
        ),
        body: Container(
            color: ColorResources.COLOR_WHITE,
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
            height: size.height,
            width: size.width,
            child: Consumer<DeliveryProvider>(
                builder: (context, deliveryProvider, child) {
              return deliveryProvider.isLoadingReceipt
                  ? LoadingThreeCircle()
                  : Container(
                      padding:
                          const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                      width: double.infinity,
                      height: size.height,
                      decoration: BoxDecoration(
                        color: ColorResources.COLOR_WHITE,
                        borderRadius: BorderRadius.circular(3),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey.withOpacity(0.2),
                        //     spreadRadius: 1,
                        //     blurRadius: 7,
                        //     offset: Offset(0, 1), // changes position of shadow
                        //   ),
                        // ],
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
                            Text("Delivery Information",
                                style: _title.copyWith(fontSize: 16)),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text("Tracking Number: ", style: _title),
                                Text(
                                    deliveryProvider.delivery.trackingNumber ??
                                        "",
                                    style: _subTitle),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text("Delivery Company: ", style: _title),
                                Text(
                                    deliveryProvider.delivery.method.toString(),
                                    style: _subTitle),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text("Delivery Date: ", style: _title),
                                Text(
                                    DateFormat('dd-MM-yyyy').format(
                                        deliveryProvider.delivery.createdAt ??
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
                                Text(deliveryProvider.sender.sender ?? "",
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
                                      deliveryProvider.sender.address ?? "",
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
                                Text(deliveryProvider.user.name ?? "",
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
                                      deliveryProvider.order.address ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 4,
                                      style: _subTitle),
                                ),
                              ],
                            ),
                            Divider(),
                            Text("Order Information",
                                style: _title.copyWith(fontSize: 16)),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text("Order ID: ", style: _title),
                                Text(deliveryProvider.order.id.toString(),
                                    style: _subTitle),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text("Order Date: ", style: _title),
                                Text(
                                    DateFormat('dd-MM-yyyy').format(
                                        deliveryProvider.order.createdAt ??
                                            DateTime.now()),
                                    style: _subTitle),
                              ],
                            ),
                            // SizedBox(height: 5),
                            // Row(
                            //   children: [
                            //     Text("Order Status: ", style: _title),
                            //     Text(deliveryProvider.order.status!,
                            //         style: _subTitle),
                            //   ],
                            // ),
                            SizedBox(height: 5),
                            Divider(),
                            const SizedBox(height: 10),
                            Text("Delivery Items",
                                style: _title.copyWith(fontSize: 16)),
                            SizedBox(height: 5),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                                  deliveryProvider.deliveryOrderDetail.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            deliveryProvider
                                                    .deliveryOrderDetail[index]
                                                    .plantName ??
                                                deliveryProvider
                                                    .deliveryOrderDetail[index]
                                                    .productName ??
                                                "",
                                            style: _title),
                                        Text(
                                            " x " +
                                                deliveryProvider
                                                    .deliveryOrderDetail[index]
                                                    .quantity
                                                    .toString(),
                                            style: _subTitle),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: 5),
                            Divider(),
                            // Spacer(),
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
                        ),
                      ),
                    );
            })));
  }
}
