import 'package:flutter/material.dart';

class EmptyWidget extends StatefulWidget {
  final bool large;
  final bool isLoading;
  final int duration;
  final bool isStart;
  EmptyWidget(
      {Key? key,
      required this.large,
      this.isLoading = true,
      this.duration = 5,
      this.isStart = false})
      : assert(duration > 0, 'Duration must greater then 0!'),
        super(key: key);

  @override
  _EmptyWidgetState createState() => _EmptyWidgetState();
}

class _EmptyWidgetState extends State<EmptyWidget> {
  bool loading = true;

  void _count() {
    debugPrint('============= Loading ===============');
    loading = widget.isLoading;
  }

  @override
  void didUpdateWidget(covariant EmptyWidget oldWidget) {
    if (widget.isLoading != oldWidget.isLoading) {
      _count();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // loading
          //     ? SizedBox(
          //         height: 3,
          //         child: LinearProgressIndicator(
          //           color: Theme.of(context).primaryColor,
          //           backgroundColor:
          //               Theme.of(context).secondaryHeaderColor.withOpacity(0.2),
          //         ),
          //       )
          //     : SizedBox(),
          SizedBox(),
          widget.large
              ? Container(
                  alignment: widget.isStart
                      ? AlignmentDirectional.topCenter
                      : AlignmentDirectional.center,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  height: MediaQuery.of(context).size.height * 0.7954,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      loading
                          ? Stack(
                              children: <Widget>[
                                Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                          begin: Alignment.bottomLeft,
                                          end: Alignment.topRight,
                                          colors: [
                                            Theme.of(context)
                                                .focusColor
                                                .withOpacity(0.7),
                                            Theme.of(context)
                                                .focusColor
                                                .withOpacity(0.05),
                                          ])),
                                  child: Icon(
                                    Icons.hourglass_empty,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    size: 70,
                                  ),
                                ),
                                Positioned(
                                  right: -30,
                                  bottom: -50,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor
                                          .withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(150),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: -20,
                                  top: -50,
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor
                                          .withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(150),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Stack(
                              children: <Widget>[
                                Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                          begin: Alignment.bottomLeft,
                                          end: Alignment.topRight,
                                          colors: [
                                            Theme.of(context)
                                                .focusColor
                                                .withOpacity(0.7),
                                            Theme.of(context)
                                                .focusColor
                                                .withOpacity(0.05),
                                          ])),
                                  child: Icon(
                                    Icons.near_me,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    size: 70,
                                  ),
                                ),
                                Positioned(
                                  right: -30,
                                  bottom: -50,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor
                                          .withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(150),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: -20,
                                  top: -50,
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor
                                          .withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(150),
                                    ),
                                  ),
                                )
                              ],
                            ),
                      SizedBox(height: 15),
                      loading
                          ? Container(
                              child: Column(
                                children: <Widget>[
                                  Opacity(
                                    opacity: 0.4,
                                    child: Text('Loading...',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300)),
                                  ),
                                  SizedBox(height: 50),
                                  SizedBox(),
                                ],
                              ),
                            )
                          : Container(
                              child: Column(
                                children: <Widget>[
                                  Opacity(
                                    opacity: 0.4,
                                    child: Text('No data available',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300)),
                                  ),
                                  SizedBox(height: 30),
                                ],
                              ),
                            ),
                    ],
                  ),
                )
              : Container(
                  alignment: AlignmentDirectional.center,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 15),
                      loading
                          ? Container(
                              child: Column(
                                children: <Widget>[
                                  Opacity(
                                    opacity: 0.4,
                                    child: Text('Loading...',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300)),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.black.withOpacity(.3),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Opacity(
                                    opacity: 0.5,
                                    child: Text('This page was empty',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                        )),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
