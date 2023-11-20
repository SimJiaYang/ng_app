import 'package:flutter/material.dart';
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
      fontSize: Dimensions.FONT_SIZE_DEFAULT,
      fontWeight: FontWeight.w300,
      color: ColorResources.COLOR_BLACK.withOpacity(0.65),
    );

    return Scaffold(
        appBar: CustomAppBar(
          isBgPrimaryColor: true,
          isCenter: false,
          isBackButtonExist: false,
          title: "Delivery Receipt",
          context: context,
        ),
        body: Container(
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
            height: size.height,
            width: size.width,
            child: Consumer<DeliveryProvider>(
                builder: (context, deliveryProvider, child) {
              return deliveryProvider.isLoadingReceipt
                  ? Loading()
                  : SingleChildScrollView();
            })));
  }
}
