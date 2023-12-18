import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nurserygardenapp/providers/bidding_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/custom_text_style.dart';
import 'package:nurserygardenapp/view/base/custom_appbar.dart';
import 'package:nurserygardenapp/view/base/page_loading.dart';
import 'package:provider/provider.dart';

class BiddingRefundScreen extends StatefulWidget {
  const BiddingRefundScreen({super.key});

  @override
  State<BiddingRefundScreen> createState() => _BiddingRefundScreenState();
}

class _BiddingRefundScreenState extends State<BiddingRefundScreen> {
  late BiddingProvider bidding_prov =
      Provider.of<BiddingProvider>(context, listen: false);

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
      if (bidding_prov.biddingRefundList.length < int.parse(params['limit']!))
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
    await bidding_prov.getBiddingRefundList(context, params,
        isLoadMore: isLoadMore, isLoad: true);
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
    return Scaffold(
      appBar: CustomAppBar(
        isCenter: false,
        isBackButtonExist: false,
        isBgPrimaryColor: true,
        context: context,
        title: "Bidding Refund List",
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        width: double.infinity,
        child: Consumer<BiddingProvider>(
            builder: (context, biddingProvider, child) {
          return biddingProvider.isLoadingRefund &&
                  biddingProvider.biddingRefundList.isEmpty
              ? LoadingThreeCircle()
              : biddingProvider.biddingRefundList.isEmpty &&
                      !biddingProvider.isLoadingRefund
                  ? Center(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'No Data Found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Stack(children: [
                      ListView.builder(
                          padding: (biddingProvider
                                          .biddingRefundNoMoreData.isNotEmpty &&
                                      !biddingProvider.isLoading ||
                                  (biddingProvider
                                          .biddingRefundNoMoreData.isEmpty &&
                                      biddingProvider.biddingRefundList.length <
                                          8))
                              ? EdgeInsets.fromLTRB(10, 0, 10, 10)
                              : EdgeInsets.only(
                                  bottom: 20, left: 10, right: 10, top: 0),
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          controller: _scrollController,
                          itemCount: biddingProvider.biddingRefundList.length +
                              ((biddingProvider.isLoading &&
                                      biddingProvider
                                              .biddingRefundList.length >=
                                          8)
                                  ? 1
                                  : biddingProvider
                                          .biddingRefundNoMoreData.isNotEmpty
                                      ? 1
                                      : 0),
                          itemBuilder: (context, index) {
                            if (index >=
                                    biddingProvider.biddingRefundList.length &&
                                biddingProvider
                                    .biddingRefundNoMoreData.isEmpty) {
                              return Center(
                                  child: LoadingAnimationWidget.waveDots(
                                      color: ColorResources.COLOR_PRIMARY,
                                      size: 40));
                            } else if (index >=
                                    biddingProvider.biddingRefundList.length &&
                                biddingProvider.biddingNoMoreData.isNotEmpty) {
                              return Container(
                                height: 50,
                              );
                            } else {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Bidding ID: ",
                                                style: CustomTextStyles(context)
                                                    .titleStyle,
                                              ),
                                              Text(
                                                biddingProvider
                                                    .biddingRefundList[index]
                                                    .biddingId
                                                    .toString(),
                                                style: CustomTextStyles(context)
                                                    .subTitleStyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Payment Way: ",
                                                style: CustomTextStyles(context)
                                                    .titleStyle,
                                              ),
                                              Text(
                                                biddingProvider
                                                        .biddingRefundList[
                                                            index]
                                                        .paymentWay ??
                                                    "",
                                                style: CustomTextStyles(context)
                                                    .subTitleStyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Payment Date: ",
                                                style: CustomTextStyles(context)
                                                    .titleStyle,
                                              ),
                                              Text(
                                                "${DateFormat('dd-MM-yyyy HH:mm').format(biddingProvider.biddingRefundList[index].updatedAt ?? DateTime.now())}",
                                                style: CustomTextStyles(context)
                                                    .subTitleStyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Refund Amount: ",
                                                style: CustomTextStyles(context)
                                                    .titleStyle,
                                              ),
                                              Text(
                                                "RM ${biddingProvider.biddingRefundList[index].amount!.toStringAsFixed(2)}",
                                                style: CustomTextStyles(context)
                                                    .subTitleStyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Refund Status: ",
                                                style: CustomTextStyles(context)
                                                    .titleStyle,
                                              ),
                                              Container(
                                                height: 20,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                  color: biddingProvider
                                                              .biddingRefundList[
                                                                  index]
                                                              .refundStatus ==
                                                          'pay'
                                                      ? Colors.orange
                                                      : Colors.green,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(5),
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    biddingProvider
                                                                .biddingRefundList[
                                                                    index]
                                                                .refundStatus ==
                                                            'pay'
                                                        ? "Pending"
                                                        : "Complete",
                                                    textAlign: TextAlign.center,
                                                    style: CustomTextStyles(
                                                            context)
                                                        .subTitleStyle
                                                        .copyWith(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.white),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          }),
                    ]);
        }),
      ),
    );
  }
}
