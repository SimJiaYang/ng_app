import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nurserygardenapp/data/model/bidding_model.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/dimensions.dart';
import 'package:nurserygardenapp/view/base/custom_space.dart';

class BiddingGridItem extends StatefulWidget {
  const BiddingGridItem({
    super.key,
    required this.bid,
    required this.onTap,
  });

  final Bidding bid;
  final void Function() onTap;

  @override
  State<BiddingGridItem> createState() => _BiddingGridItemState();
}

class _BiddingGridItemState extends State<BiddingGridItem> {
  late StreamController<Duration> countdownController;
  late Stream<Duration> countdownStream;

  @override
  void initState() {
    super.initState();
    countdownController = StreamController<Duration>();
    countdownStream = countdownController.stream;

    // Start the countdown timer
    Timer.periodic(const Duration(seconds: 1), (timer) {
      countdownController.add(widget.bid.endTime!.difference(DateTime.now()));
      // // Check if the countdown has reached 0
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var theme = Theme.of(context).textTheme;
    TextStyle _title = theme.headlineMedium!.copyWith(
      fontSize: Dimensions.FONT_SIZE_DEFAULT,
      color: ColorResources.COLOR_BLACK.withOpacity(0.8),
    );
    TextStyle _subTitle = theme.headlineMedium!.copyWith(
      fontSize: Dimensions.FONT_SIZE_DEFAULT,
      color: const Color.fromRGBO(45, 45, 45, 1).withOpacity(0.6),
    );
    return InkWell(
      onTap: widget.onTap,
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            // border: Border.all(width: 0.2, color: ColorResources.COLOR_PRIMARY),
            borderRadius: BorderRadius.circular(10),
            color: ColorResources.COLOR_WHITE,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  offset: const Offset(0, 2),
                  blurRadius: 10.0),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: CachedNetworkImage(
                      filterQuality: FilterQuality.high,
                      imageUrl: "${widget.bid.image!}",
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Container(
                          width: double.infinity,
                          height: 20,
                          color: Colors.grey[400],
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )),
                VerticalSpacing(),
                Text(
                  widget.bid.name!,
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 14,
                      ),
                ),
                VerticalSpacing(),
                Row(
                  children: [
                    Flexible(
                      child: StreamBuilder<Duration>(
                        stream: countdownStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            Duration remainingTime = snapshot.data!;
                            if (remainingTime.inSeconds <= 0) {
                              return Container(
                                  child: Text(
                                'Bidding Ended',
                                style: _subTitle.copyWith(
                                  color: ColorResources.APPBAR_HEADER_COLOR,
                                  fontSize: 12,
                                ),
                              )); // Countdown is zero or less, return an empty container
                            }
                            return Text(
                              formatRemainingTime(remainingTime),
                              style: _subTitle.copyWith(
                                color: ColorResources.APPBAR_HEADER_COLOR,
                                fontSize: 12,
                              ),
                            );
                          } else {
                            return Text(
                              'Loading...',
                              style: _subTitle.copyWith(
                                color: ColorResources.APPBAR_HEADER_COLOR,
                                fontSize: 12,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                VerticalSpacing(),
                Row(
                  children: [
                    Icon(Icons.arrow_upward_rounded,
                        color: ColorResources.COLOR_PRIMARY, size: 16),
                    Text(
                      "RM " + widget.bid.highestAmt!.toStringAsFixed(2),
                      style: _subTitle.copyWith(
                        color: ColorResources.COLOR_BLUE,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

String formatRemainingTime(Duration remainingTime) {
  if (remainingTime.inHours > 0) {
    return "${remainingTime.inHours} hours ${remainingTime.inMinutes.remainder(60)} minutes ${remainingTime.inSeconds.remainder(60)} seconds left";
  } else if (remainingTime.inMinutes > 0) {
    return "${remainingTime.inMinutes} minutes ${remainingTime.inSeconds.remainder(60)} seconds left";
  } else {
    return "${remainingTime.inSeconds} seconds left";
  }
}
