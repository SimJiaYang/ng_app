import 'package:flutter/material.dart';
import 'package:nurserygardenapp/data/model/bidding_model.dart';

class BiddingDetailScreen extends StatefulWidget {
  final Bidding bidding;
  const BiddingDetailScreen({super.key, required this.bidding});

  @override
  State<BiddingDetailScreen> createState() => _BiddingDetailScreenState();
}

class _BiddingDetailScreenState extends State<BiddingDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
