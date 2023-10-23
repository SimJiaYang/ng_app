import 'package:flutter/material.dart';
import 'package:nurserygardenapp/providers/order_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
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
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white, // <-- SEE HERE
        ),
        backgroundColor: ColorResources.COLOR_PRIMARY,
        title: Text(
          "Order Detail",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
      ),
      body: Container(),
    );
  }
}
