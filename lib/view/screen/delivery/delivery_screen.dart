import 'package:flutter/material.dart';
import 'package:nurserygardenapp/providers/delivery_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/dimensions.dart';
import 'package:nurserygardenapp/view/base/circular_indicator.dart';
import 'package:nurserygardenapp/view/base/custom_appbar.dart';
import 'package:provider/provider.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  late DeliveryProvider deliver_prov =
      Provider.of<DeliveryProvider>(context, listen: false);
  final _scrollController = ScrollController();

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
      if (deliver_prov.deliveryList.length < int.parse(params['limit']!))
        return;
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
    await deliver_prov.getDeliveryList(context, params, isLoadMore: isLoadMore);
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
    TextStyle _subTitle = theme.headlineMedium!.copyWith(
      fontSize: Dimensions.FONT_SIZE_DEFAULT,
      fontWeight: FontWeight.w300,
      color: ColorResources.COLOR_BLACK.withOpacity(0.7),
    );

    return Scaffold(
      appBar: CustomAppBar(
        isBackButtonExist: false,
        isBgPrimaryColor: true,
        title: 'Delivery',
        context: context,
        isCenter: false,
      ),
      body: SizedBox(
          width: size.width,
          height: size.height,
          child: Consumer<DeliveryProvider>(
              builder: (context, deliveryProvider, child) {
            return deliveryProvider.deliveryList.isEmpty &&
                    deliveryProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : deliveryProvider.deliveryList.isEmpty &&
                        !deliveryProvider.isLoading
                    ? Center(child: Text('No Data Found'))
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: deliveryProvider.deliveryList.length +
                            ((deliveryProvider.isLoading &&
                                    deliveryProvider.deliveryList.length >= 8)
                                ? 1
                                : deliveryProvider.noMoreDataMessage.isNotEmpty
                                    ? 1
                                    : 0),
                        padding: (deliveryProvider
                                        .noMoreDataMessage.isNotEmpty &&
                                    !deliveryProvider.isLoading ||
                                (deliveryProvider.noMoreDataMessage.isEmpty &&
                                    deliveryProvider.deliveryList.length < 8))
                            ? EdgeInsets.fromLTRB(10, 0, 10, 10)
                            : EdgeInsets.only(
                                bottom: 235, left: 10, right: 10, top: 0),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          if (index >= deliveryProvider.deliveryList.length &&
                              deliveryProvider.noMoreDataMessage.isEmpty) {
                            return CircularProgress();
                          } else if (index >=
                                  deliveryProvider.deliveryList.length &&
                              deliveryProvider.noMoreDataMessage.isNotEmpty) {
                            return Container(
                              height: 50,
                            );
                          } else if (index >=
                                  deliveryProvider.deliveryList.length &&
                              deliveryProvider.noMoreDataMessage.isNotEmpty) {
                            return Container(
                              height: 20,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Center(
                                child: Text(deliveryProvider.noMoreDataMessage,
                                    style: TextStyle(
                                        color: Colors.grey.withOpacity(0.5))),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          offset: const Offset(0, 2),
                                          blurRadius: 10.0),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          deliveryProvider.deliveryList[index]
                                              .trackingNumber
                                              .toString(),
                                          style: _subTitle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        });
          })),
    );
  }
}
