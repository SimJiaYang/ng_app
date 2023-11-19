import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nurserygardenapp/data/model/delivery_model.dart';
import 'package:nurserygardenapp/data/model/order_model.dart';
import 'package:nurserygardenapp/providers/delivery_provider.dart';
import 'package:nurserygardenapp/providers/order_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/dimensions.dart';
import 'package:nurserygardenapp/view/base/custom_appbar.dart';
import 'package:nurserygardenapp/view/base/image_enlarge_widget.dart';
import 'package:nurserygardenapp/view/base/page_loading.dart';
import 'package:provider/provider.dart';

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
  bool isLoading = false;

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
    print(widget.deliveryId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    setState(() {
      isLoading = true;
    });
    delivery = _deliveryProvider.deliveryList.firstWhere(
        (element) => element.id.toString() == widget.deliveryId, orElse: () {
      // Get from the route args
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      print(args);
      Order order = _orderProv.orderList.firstWhere(
          (element) => element.id.toString() == args['orderID'].toString());
      return Delivery(
        id: 0,
        orderId: order.id,
        orderAddress: order.address,
        orderDate: order.createdAt,
        expectedDate: DateTime.now(),
        status: "",
        trackingNumber: "",
        imageURL: "",
        createdAt: order.createdAt,
        updatedAt: order.updatedAt,
      );
    });
    if (delivery.status == "ship") {
      _currentStep = 1;
    } else if (delivery.status == "delivered") {
      _currentStep = 2;
    } else {
      _currentStep = 0;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var theme = Theme.of(context).textTheme;
    TextStyle _title = theme.headlineMedium!.copyWith(
      fontSize: Dimensions.FONT_SIZE_DEFAULT,
      color: ColorResources.COLOR_BLACK.withOpacity(0.85),
    );
    TextStyle _subTitle = theme.headlineMedium!.copyWith(
      fontSize: Dimensions.FONT_SIZE_DEFAULT,
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
        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
        height: size.height,
        width: size.width,
        child: isLoading
            ? Loading()
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
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
                                      style: _title),
                                if (delivery.status == "ship")
                                  Text("Your parcel is on the way",
                                      style: _title),
                                if (delivery.status == "delivered")
                                  Text("Your Parcel has been delivered",
                                      style: _title),
                                SizedBox(height: 10),
                                if (delivery.status == "")
                                  Row(
                                    children: [
                                      Text("Order Date: ", style: _subTitle),
                                      Text(
                                          DateFormat('dd-MM-yyyy')
                                              .format(delivery.orderDate!),
                                          style: _subTitle),
                                    ],
                                  ),
                                if (delivery.status == "ship")
                                  Row(
                                    children: [
                                      Text("Expected Date: ", style: _subTitle),
                                      Text(
                                          DateFormat('dd-MM-yyyy')
                                              .format(delivery.expectedDate!),
                                          style: _subTitle),
                                    ],
                                  ),
                                if (delivery.status == "delivered")
                                  Text(
                                      DateFormat('dd-MM-yyyy').format(
                                          delivery.updatedAt ?? DateTime.now()),
                                      style: _subTitle),
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
                                  Text("Order ID: ", style: _title),
                                  SizedBox(height: 10),
                                  Text(delivery.orderId.toString(),
                                      style: _subTitle),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Order Address: ", style: _title),
                                  SizedBox(height: 10),
                                  Flexible(
                                    child: Text(delivery.orderAddress ?? "",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 4,
                                        style: _subTitle),
                                  ),
                                ],
                              ),
                            ]),
                      ),
                    SizedBox(height: 20),
                    Container(
                      padding:
                          const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
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
                                Text("Delivery Status", style: _title),
                                Spacer(),
                                Text(delivery.trackingNumber ?? "",
                                    style: _subTitle),
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                            style: _title.copyWith(
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
                                    style: _title,
                                  ),
                                  subtitle: Text(
                                    DateFormat('dd-MM-yyyy').format(
                                        delivery.orderDate ?? DateTime.now()),
                                    style: _subTitle.copyWith(fontSize: 12),
                                  ),
                                  content: Text(
                                      'Seller is preparing your parcel for shipment.',
                                      style: _subTitle),
                                  isActive: true,
                                ),
                                Step(
                                  state: StepState.indexed,
                                  title: Text(
                                    'Order Shipped',
                                    style: _title,
                                  ),
                                  subtitle: delivery.status == "delivered" ||
                                          delivery.status == "ship"
                                      ? Text(
                                          DateFormat('dd-MM-yyyy')
                                              .format(delivery.createdAt!),
                                          style:
                                              _subTitle.copyWith(fontSize: 12),
                                        )
                                      : null,
                                  content: Text(
                                      'Your order has been shipped and is on the way.',
                                      style: _subTitle),
                                  isActive: delivery.status == "delivered" ||
                                      delivery.status == "ship",
                                ),
                                Step(
                                  state: StepState.complete,
                                  title: Text(
                                    'Order Delivered',
                                    style: _title,
                                  ),
                                  subtitle: delivery.status == "delivered"
                                      ? Text(
                                          DateFormat('dd-MM-yyyy')
                                              .format(delivery.updatedAt!),
                                          style:
                                              _subTitle.copyWith(fontSize: 12))
                                      : null,
                                  content: Text(
                                      'Your order has been delivered and received.',
                                      style: _subTitle),
                                  isActive: delivery.status == "delivered",
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
