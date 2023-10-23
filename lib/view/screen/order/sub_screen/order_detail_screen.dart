import 'package:flutter/material.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderID;

  const OrderDetailScreen({required this.orderID, super.key});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Detail'),
      ),
      body: const Placeholder(),
    );
  }
}
