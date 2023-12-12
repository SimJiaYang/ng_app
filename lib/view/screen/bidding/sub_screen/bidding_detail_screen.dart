import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nurserygardenapp/data/model/bidding_model.dart';
import 'package:nurserygardenapp/providers/bidding_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/custom_text_style.dart';
import 'package:nurserygardenapp/util/dimensions.dart';
import 'package:nurserygardenapp/view/base/custom_space.dart';
import 'package:nurserygardenapp/view/base/image_enlarge_widget.dart';
import 'package:nurserygardenapp/view/base/page_loading.dart';
import 'package:provider/provider.dart';

class BiddingDetailScreen extends StatefulWidget {
  final String biddingID;
  const BiddingDetailScreen({super.key, required this.biddingID});

  @override
  State<BiddingDetailScreen> createState() => _BiddingDetailScreenState();
}

class _BiddingDetailScreenState extends State<BiddingDetailScreen> {
  late BiddingProvider biddingProvider =
      Provider.of<BiddingProvider>(context, listen: false);
  late Bidding bidding = Bidding();
  bool isLoading = true;
  late Timer fetchTimer;
  double highestAmount = 0;

  @override
  void initState() {
    super.initState();
    fetchTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      updateHighestAmount();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      return _loadData();
    });
  }

  void updateHighestAmount() async {
    await biddingProvider.getBidDetail(context, widget.biddingID).then((value) {
      if (value == true) {
        setState(() {
          highestAmount = biddingProvider.bid.highestAmt!.toDouble();
        });
      }
    });
  }

  _loadData() {
    bidding = biddingProvider.biddingList
        .where((element) => element.biddingId.toString() == widget.biddingID)
        .first;
    setState(() {
      isLoading = false;
      highestAmount = (bidding.highestAmt).toDouble() ?? 0;
    });
  }

  @override
  void dispose() {
    fetchTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.white, // <-- SEE HERE
          ),
          backgroundColor: ColorResources.COLOR_PRIMARY,
        ),
        body: SafeArea(
          child: isLoading
              ? LoadingThreeCircle()
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          color: ColorResources.COLOR_WHITE,
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return ImageEnlargeWidget(
                                  tag: "plant_${bidding.id}",
                                  url: "${bidding.image}",
                                );
                              }));
                            },
                            child: Hero(
                              tag: "plant_${bidding.id}",
                              child: CachedNetworkImage(
                                filterQuality: FilterQuality.high,
                                height: 300,
                                fit: BoxFit.fitHeight,
                                imageUrl: "${bidding.image}",
                                placeholder: (context, url) => Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Center(
                                      child: CircularProgressIndicator(
                                    color: ColorResources.COLOR_GRAY,
                                  )),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          color: ColorResources.COLOR_WHITE,
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${bidding.name}",
                                  style: CustomTextStyles(context)
                                      .titleStyle
                                      .copyWith(
                                          fontSize:
                                              Dimensions.FONT_SIZE_LARGE)),
                              VerticalSpacing(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: ColorResources.COLOR_WHITE,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        offset: const Offset(0, 2),
                                        blurRadius: 15.0),
                                  ],
                                ),
                                child: Text(
                                    "Highest Bid: RM ${highestAmount.toStringAsFixed(2)}",
                                    style: CustomTextStyles(context)
                                        .titleStyle
                                        .copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_LARGE,
                                            color:
                                                ColorResources.COLOR_PRIMARY)),
                              ),
                            ],
                          ),
                        ),
                        VerticalSpacing(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          color: ColorResources.COLOR_WHITE,
                          padding: EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Category:",
                                  style: CustomTextStyles(context).titleStyle),
                              HorizontalSpacing(
                                width: 3,
                              ),
                              Text("${bidding.categoryName}",
                                  style:
                                      CustomTextStyles(context).subTitleStyle),
                            ],
                          ),
                        ),
                        VerticalSpacing(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          color: ColorResources.COLOR_WHITE,
                          padding: EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Plant Origin:",
                                  style: CustomTextStyles(context).titleStyle),
                              HorizontalSpacing(
                                width: 3,
                              ),
                              Text("${bidding.origin}",
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      CustomTextStyles(context).subTitleStyle),
                              Expanded(child: Container()),
                              Text("Mature Height:",
                                  style: CustomTextStyles(context).titleStyle),
                              HorizontalSpacing(
                                width: 3,
                              ),
                              Text("${bidding.matureHeight} m",
                                  style:
                                      CustomTextStyles(context).subTitleStyle)
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          color: ColorResources.COLOR_WHITE,
                          padding: EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Sunlight Need:",
                                  style: CustomTextStyles(context).titleStyle),
                              HorizontalSpacing(
                                width: 3,
                              ),
                              Text("${bidding.sunlightNeed}",
                                  style:
                                      CustomTextStyles(context).subTitleStyle),
                              Expanded(child: Container()),
                              Text("Water Need:",
                                  style: CustomTextStyles(context).titleStyle),
                              HorizontalSpacing(
                                width: 3,
                              ),
                              Text("${bidding.waterNeed}",
                                  style:
                                      CustomTextStyles(context).subTitleStyle)
                            ],
                          ),
                        ),
                        VerticalSpacing(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          color: ColorResources.COLOR_WHITE,
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Description",
                                  style: CustomTextStyles(context).titleStyle),
                              VerticalSpacing(
                                height: 10,
                              ),
                              Text("${bidding.description}",
                                  textAlign: TextAlign.justify,
                                  style:
                                      CustomTextStyles(context).subTitleStyle),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ));
  }
}
