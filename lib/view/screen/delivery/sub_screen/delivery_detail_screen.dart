import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nurserygardenapp/data/model/delivery_model.dart';
import 'package:nurserygardenapp/data/model/order_model.dart';
import 'package:nurserygardenapp/helper/courier_helper.dart';
import 'package:nurserygardenapp/providers/delivery_provider.dart';
import 'package:nurserygardenapp/providers/order_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/custom_text_style.dart';
import 'package:nurserygardenapp/util/dimensions.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/base/custom_appbar.dart';
import 'package:nurserygardenapp/view/base/image_enlarge_widget.dart';
import 'package:nurserygardenapp/view/base/page_loading.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryDetailScreen extends StatefulWidget {
  final String deliveryId;
  const DeliveryDetailScreen({
    super.key,
    required this.deliveryId,
  });

  @override
  State<DeliveryDetailScreen> createState() => _DeliveryDetailScreenState();
}

class _DeliveryDetailScreenState extends State<DeliveryDetailScreen> {
  late OrderProvider _orderProv =
      Provider.of<OrderProvider>(context, listen: false);
  late DeliveryProvider _deliveryProvider =
      Provider.of<DeliveryProvider>(context, listen: false);

  Delivery delivery = Delivery();
  int _currentStep = 0;

  void tapped(int step) {
    setState(() => _currentStep = step);
  }

  void continued() {
    FocusScope.of(context).unfocus();
    return null;
    // _currentStep < 3 ? setState(() => _currentStep += 1) : null;
  }

  void cancel() {
    FocusScope.of(context).unfocus();
    return null;
    // _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  _launchURL() async {
    String courierCompany = delivery.method ?? "J&T";

    // Retrieve courier information based on the provided name
    Map<String, dynamic>? courier =
        CourierHelper.getCourierInfo(courierCompany);

    if (courier != null) {
      String url = courier['website'] ?? "";

      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    } else {
      throw 'Courier not found';
    }
  }

  void _loadData() async {
    // Get from the route args
    if (widget.deliveryId == "0") {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      Order _order = _orderProv.orderList.firstWhere(
          (element) => element.id.toString() == args['orderID'].toString());
      bool result = await _deliveryProvider
          .getDeliveryList(context, {'order_id': _order.id.toString()});
      if (result) {
        delivery = _deliveryProvider.deliveryList.isEmpty
            ? Delivery(
                id: 0,
                orderId: _order.id,
                orderAddress: _order.address,
                orderDate: _order.createdAt,
                expectedDate: DateTime.now(),
                status: "",
                trackingNumber: "",
                imageURL: "",
                createdAt: _order.createdAt,
                updatedAt: _order.updatedAt,
              )
            : _deliveryProvider.deliveryList.first;
      }
    } else {
      bool result = await _deliveryProvider
          .getDeliveryDetail(context, {'id': widget.deliveryId});
      if (result) {
        delivery = _deliveryProvider.deliveryDetail;
      }
    }
    if (delivery.status == "ship") {
      _currentStep = 1;
    } else if (delivery.status == "delivered") {
      _currentStep = 2;
    } else {
      _currentStep = 0;
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar(
        isBgPrimaryColor: true,
        isCenter: false,
        isBackButtonExist: false,
        title: "Delivery Detail",
        context: context,
      ),
      body: Container(
        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
        height: size.height,
        width: size.width,
        child: Consumer2<OrderProvider, DeliveryProvider>(
            builder: (context, orderProvider, deliveryProvider, child) {
          return orderProvider.isLoading ||
                  deliveryProvider.isLoading ||
                  deliveryProvider.isLoadingDetail
              ? LoadingThreeCircle()
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(
                            Dimensions.PADDING_SIZE_DEFAULT),
                        decoration: BoxDecoration(
                          color: ColorResources.COLOR_WHITE,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        width: double.infinity,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (delivery.status == "")
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 15, 10),
                                  child: Icon(
                                    Icons.inventory_rounded,
                                    size: 30,
                                    color: ColorResources.COLOR_PRIMARY,
                                  ),
                                ),
                              if (delivery.status == "ship")
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 15, 10),
                                  child: Icon(
                                    Icons.local_shipping_outlined,
                                    size: 30,
                                    color: ColorResources.COLOR_PRIMARY,
                                  ),
                                ),
                              if (delivery.status == "delivered")
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 15, 10),
                                  child: Icon(
                                    Icons.task_alt_outlined,
                                    size: 30,
                                    color: ColorResources.COLOR_PRIMARY,
                                  ),
                                ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (delivery.status == "")
                                    Text("Seller is preparing your order",
                                        style: CustomTextStyles(context)
                                            .titleStyle),
                                  if (delivery.status == "ship")
                                    Text("Your parcel is on the way",
                                        style: CustomTextStyles(context)
                                            .titleStyle),
                                  if (delivery.status == "delivered")
                                    Text("Your Parcel has been delivered",
                                        style: CustomTextStyles(context)
                                            .titleStyle),
                                  SizedBox(height: 10),
                                  if (delivery.status == "")
                                    Row(
                                      children: [
                                        Text("Order Date: ",
                                            style: CustomTextStyles(context)
                                                .subTitleStyle),
                                        Text(
                                            DateFormat('dd-MM-yyyy')
                                                .format(delivery.orderDate!),
                                            style: CustomTextStyles(context)
                                                .subTitleStyle),
                                      ],
                                    ),
                                  if (delivery.status == "ship")
                                    Row(
                                      children: [
                                        Text("Expected Date: ",
                                            style: CustomTextStyles(context)
                                                .subTitleStyle),
                                        Text(
                                            DateFormat('dd-MM-yyyy')
                                                .format(delivery.expectedDate!),
                                            style: CustomTextStyles(context)
                                                .subTitleStyle),
                                      ],
                                    ),
                                  if (delivery.status == "delivered")
                                    Text(
                                        DateFormat('dd-MM-yyyy').format(
                                            delivery.updatedAt ??
                                                DateTime.now()),
                                        style: CustomTextStyles(context)
                                            .subTitleStyle),
                                ],
                              ),
                            ]),
                      ),
                      SizedBox(height: 20),
                      if (delivery.status != null)
                        Container(
                          padding: const EdgeInsets.all(
                              Dimensions.PADDING_SIZE_DEFAULT),
                          decoration: BoxDecoration(
                            color: ColorResources.COLOR_WHITE,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          width: double.infinity,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text("Order ID: ",
                                        style: CustomTextStyles(context)
                                            .titleStyle),
                                    SizedBox(height: 10),
                                    Text(delivery.orderId.toString(),
                                        style: CustomTextStyles(context)
                                            .subTitleStyle),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Order Address: ",
                                        style: CustomTextStyles(context)
                                            .titleStyle),
                                    SizedBox(height: 10),
                                    Flexible(
                                      child: Text(delivery.orderAddress ?? "",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 4,
                                          style: CustomTextStyles(context)
                                              .subTitleStyle),
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      // Click to view delivery order item
                      if (delivery.status == "delivered" ||
                          delivery.status == "ship")
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              Routes.getDeliveryReceiptRoute(
                                  delivery.id.toString()),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              decoration: BoxDecoration(
                                color: ColorResources.COLOR_WHITE,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Click here to view delivery detail",
                                      style:
                                          CustomTextStyles(context).titleStyle),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: ColorResources.COLOR_PRIMARY,
                                    size: 16,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),

                      // Click to view delivery order item
                      if (delivery.status == "delivered" ||
                          delivery.status == "ship")
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: GestureDetector(
                            onTap: () {
                              _launchURL();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              decoration: BoxDecoration(
                                color: ColorResources.COLOR_WHITE,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                      "Your Courier Company : ${delivery.method ?? ""}",
                                      style:
                                          CustomTextStyles(context).titleStyle),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "Click here to go your courier website ",
                                          style: CustomTextStyles(context)
                                              .titleStyle),
                                      Icon(
                                        Icons.touch_app,
                                        color: ColorResources.COLOR_PRIMARY,
                                        size: 16,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(
                            Dimensions.PADDING_SIZE_DEFAULT),
                        decoration: BoxDecoration(
                          color: ColorResources.COLOR_WHITE,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        width: double.infinity,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text("Delivery Status",
                                      style:
                                          CustomTextStyles(context).titleStyle),
                                  Spacer(),
                                  if (delivery.status == "delivered" ||
                                      delivery.status == "ship")
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: InkWell(
                                        onTap: () {
                                          Clipboard.setData(new ClipboardData(
                                              text: delivery.trackingNumber ??
                                                  ""));
                                        },
                                        child: Text(
                                          "COPY",
                                          style: CustomTextStyles(context)
                                              .titleStyle
                                              .copyWith(
                                                  color: ColorResources
                                                      .COLOR_PRIMARY),
                                        ),
                                      ),
                                    ),
                                  if (delivery.status == "delivered" ||
                                      delivery.status == "ship")
                                    Text(delivery.trackingNumber ?? "",
                                        style: CustomTextStyles(context)
                                            .subTitleStyle),
                                ],
                              ),
                              Stepper(
                                connectorColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    return ColorResources.COLOR_GREY;
                                  }
                                  return ColorResources.COLOR_PRIMARY;
                                }),
                                controlsBuilder: (context, details) {
                                  if (delivery.status == "delivered") {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            // print(delivery.imageURL!);
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (_) {
                                              return ImageEnlargeWidget(
                                                tag: "delivery_${delivery.id}",
                                                url: "${delivery.imageURL!}",
                                              );
                                            }));
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                5, 10, 5, 0),
                                            child: Text(
                                              "View Proof of Delivery",
                                              style: CustomTextStyles(context)
                                                  .titleStyle
                                                  .copyWith(
                                                      color: ColorResources
                                                          .COLOR_PRIMARY),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  return Container();
                                },
                                currentStep: _currentStep,
                                steps: [
                                  Step(
                                    state: StepState.indexed,
                                    title: Text(
                                      'Order Placed',
                                      style:
                                          CustomTextStyles(context).titleStyle,
                                    ),
                                    subtitle: Text(
                                      DateFormat('dd-MM-yyyy HH:mm').format(
                                          delivery.orderDate ?? DateTime.now()),
                                      style: CustomTextStyles(context)
                                          .subTitleStyle
                                          .copyWith(fontSize: 12),
                                    ),
                                    content: Text(
                                        'Seller is preparing your parcel for shipment.',
                                        style: CustomTextStyles(context)
                                            .subTitleStyle),
                                    isActive: true,
                                  ),
                                  Step(
                                    state: StepState.indexed,
                                    title: Text(
                                      'Order Shipped',
                                      style:
                                          CustomTextStyles(context).titleStyle,
                                    ),
                                    subtitle: delivery.status == "delivered" ||
                                            delivery.status == "ship"
                                        ? Text(
                                            DateFormat('dd-MM-yyyy HH:mm')
                                                .format(delivery.createdAt!),
                                            style: CustomTextStyles(context)
                                                .subTitleStyle
                                                .copyWith(fontSize: 12),
                                          )
                                        : null,
                                    content: Text(
                                        'Your order has been shipped and is on the way.',
                                        style: CustomTextStyles(context)
                                            .subTitleStyle),
                                    isActive: delivery.status == "delivered" ||
                                        delivery.status == "ship",
                                  ),
                                  Step(
                                    state: StepState.complete,
                                    title: Text(
                                      'Order Delivered',
                                      style:
                                          CustomTextStyles(context).titleStyle,
                                    ),
                                    subtitle: delivery.status == "delivered"
                                        ? Text(
                                            DateFormat('dd-MM-yyyy HH:mm')
                                                .format(delivery.updatedAt!),
                                            style: CustomTextStyles(context)
                                                .subTitleStyle
                                                .copyWith(fontSize: 12))
                                        : null,
                                    content: Text(
                                        'Your order has been delivered and received.',
                                        style: CustomTextStyles(context)
                                            .subTitleStyle),
                                    isActive: delivery.status == "delivered",
                                  ),
                                ],
                              ),
                            ]),
                      ),
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
