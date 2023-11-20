import 'package:flutter/material.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/dimensions.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/screen/order/widget/shipping_icon.dart';

class ShippingStatus extends StatefulWidget {
  final String orderID;
  final String status;

  ShippingStatus({
    super.key,
    required this.status,
    required this.orderID,
  });

  @override
  State<ShippingStatus> createState() => _ShippingStatusState();
}

class _ShippingStatusState extends State<ShippingStatus> {
  @override
  void initState() {
    super.initState();
    print(widget.status);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    TextStyle _title = theme.headlineMedium!.copyWith(
      fontSize: Dimensions.FONT_SIZE_DEFAULT,
      color: ColorResources.COLOR_BLACK.withOpacity(0.8),
    );
    TextStyle _subTitle = theme.headlineMedium!.copyWith(
      fontSize: Dimensions.FONT_SIZE_DEFAULT,
      color: ColorResources.COLOR_BLACK.withOpacity(0.6),
    );
    Size size = MediaQuery.of(context).size;

    Widget payWidget = Container(
      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
      decoration: BoxDecoration(
        color: ColorResources.COLOR_WHITE,
        borderRadius: BorderRadius.circular(5),
      ),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ShippingIcon(
            icon: Icons.paid_outlined,
            color: ColorResources.COLOR_BLACK.withOpacity(0.8),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Payment Pending....", style: _title.copyWith(fontSize: 16)),
              SizedBox(height: 3),
              Text("Please pay to confirm your order",
                  style: _subTitle.copyWith(fontSize: 14))
            ],
          )
        ],
      ),
    );

    Widget cancelWidget = Container(
      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
      decoration: BoxDecoration(
        color: ColorResources.COLOR_WHITE,
        borderRadius: BorderRadius.circular(5),
      ),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ShippingIcon(
            icon: Icons.close_sharp,
            color: Colors.red.withOpacity(0.8),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Order Cancelled", style: _title.copyWith(fontSize: 16)),
              SizedBox(height: 3),
              Text("Your order has been cancelled",
                  style: _subTitle.copyWith(fontSize: 14))
            ],
          )
        ],
      ),
    );

    Widget shipWidget = GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.getDeliveryDetailRoute("0"),
            arguments: {
              "orderID": widget.orderID,
            });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
        decoration: BoxDecoration(
          color: ColorResources.COLOR_WHITE,
          borderRadius: BorderRadius.circular(5),
        ),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ShippingIcon(
              icon: Icons.inventory_rounded,
              color: ColorResources.COLOR_PRIMARY,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Order Placed", style: _title.copyWith(fontSize: 16)),
                SizedBox(height: 3),
                Text("Seller is preparing your order",
                    style: _subTitle.copyWith(fontSize: 14))
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: ColorResources.COLOR_PRIMARY,
            )
          ],
        ),
      ),
    );

    Widget receiveWidget = GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.getDeliveryDetailRoute("0"),
            arguments: {
              "orderID": widget.orderID,
            });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
        decoration: BoxDecoration(
          color: ColorResources.COLOR_WHITE,
          borderRadius: BorderRadius.circular(5),
        ),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ShippingIcon(
              icon: Icons.local_shipping_outlined,
              color: ColorResources.COLOR_PRIMARY,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Order Shipped", style: _title.copyWith(fontSize: 16)),
                SizedBox(height: 3),
                Text("Your parcel is on the way",
                    style: _subTitle.copyWith(fontSize: 14))
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: ColorResources.COLOR_PRIMARY,
            )
          ],
        ),
      ),
    );

    Widget completeWidget = GestureDetector(
      onTap: () {
        Navigator.pushNamed(
            context,
            Routes.getOrderDeliveryRoute(
              widget.orderID,
            ));
        // Navigator.pushNamed(context, Routes.getDeliveryDetailRoute("0"),
        //     arguments: {
        //       "orderID": widget.orderID,
        //     });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
        decoration: BoxDecoration(
          color: ColorResources.COLOR_WHITE,
          borderRadius: BorderRadius.circular(5),
        ),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ShippingIcon(
              icon: Icons.task_alt_outlined,
              color: ColorResources.COLOR_PRIMARY,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Order Delivered", style: _title.copyWith(fontSize: 16)),
                SizedBox(height: 3),
                Text("Your parcel has been delivered",
                    style: _subTitle.copyWith(fontSize: 14))
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: ColorResources.COLOR_PRIMARY,
            )
          ],
        ),
      ),
    );

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.status == "pay") payWidget,
          if (widget.status == "ship") shipWidget,
          if (widget.status == "receive") receiveWidget,
          if (widget.status == "completed") completeWidget,
          if (widget.status == "cancel") cancelWidget,
          // SizedBox(
          //   height: 20,
          // )
          // if (delivery.status == "delivered")
          //   Container(
          //     padding: const EdgeInsets.fromLTRB(0, 10, 15, 10),
          //     child: Icon(
          //       Icons.check_circle_outline,
          //       size: 30,
          //       color: ColorResources.COLOR_PRIMARY,
          //     ),
          //   ),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     if (delivery.status == "ship")
          //       Text("Expected Delivery Date", style: _title),
          //     if (delivery.status == "delivered")
          //       Text("Your Parcel has been delivered", style: _title),
          //     SizedBox(height: 10),
          //     if (delivery.status == "ship")
          //       Text(
          //           DateFormat('dd-MM-yyyy')
          //               .format(delivery.expectedDate!),
          //           style: _subTitle),
          //     if (delivery.status == "delivered")
          //       Text(
          //           DateFormat('dd-MM-yyyy')
          //               .format(delivery.updatedAt ?? DateTime.now()),
          //           style: _subTitle),
          //   ],
          // ),
        ],
      ),
    );
  }
}
