import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:nurserygardenapp/providers/auth_provider.dart';
import 'package:nurserygardenapp/providers/splash_provider.dart';
import 'package:nurserygardenapp/util/app_constants.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/font_styles.dart';
import 'package:nurserygardenapp/util/images.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/base/custom_snackbar.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;
  bool NoConnection = false;

  @override
  void initState() {
    super.initState();
    bool _firstTime = true;
    checkConnection();
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (!_firstTime) {
        checkConnection();
        bool isNotConnected = (result == ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile);
        if (!isNotConnected) {
          _route();
        } else {
          showCustomSnackBar(
            'No Internet Connection Found,Please check your connection.',
            context,
            displayDuration: 10,
          );
        }
        _firstTime = false;
      }
      _route();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _onConnectivityChanged.cancel();
  }

  void _route() {
    Provider.of<SplashProvider>(context, listen: false)
        .initConfig(_globalKey)
        .then((bool success) {
      if (success) {
        debugPrint('start routing, check for user login');
        _checkToken();
      }
    });
  }

  void _checkToken() {
    Provider.of<AuthProvider>(context, listen: false)
        .checkUserLogin()
        .then((value) => {
              if (value)
                {
                  debugPrint('Logged in'),
                  Navigator.pushNamedAndRemoveUntil(
                      context, Routes.getMainRoute(), (route) => false)
                }
              else
                {
                  Navigator.pushNamedAndRemoveUntil(
                      context, Routes.getLoginRoute(), (route) => false)
                }
            });
  }

  void checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    this.NoConnection = connectivityResult == ConnectivityResult.none;
    print(NoConnection);
    if (NoConnection) {
      showCustomSnackBar(
        'No Internet Connection Found,Please check your connection.',
        context,
        displayDuration: 10,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(Images.splash),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      ColorResources.COLOR_BLACK.withOpacity(.2),
                      BlendMode.darken)),
            ),
          ),
          Positioned.fill(
            child: Align(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppConstants.APP_NAME,
                      style: RubikMedium.copyWith(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    NoConnection
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                                color: Colors.amber.shade700,
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              children: [
                                Text(
                                  'No Internet Connection Found',
                                  style: RubikMedium.copyWith(
                                      color: ColorResources.COLOR_WHITE,
                                      fontSize: 18),
                                ),
                                Text(
                                  'Please check your connection.',
                                  textAlign: TextAlign.center,
                                  style: RubikMedium.copyWith(
                                      color: ColorResources.COLOR_WHITE,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          )
                        : SizedBox.shrink(),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
