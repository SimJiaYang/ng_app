// import 'dart:ffi';

import 'package:fluro/fluro.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/screen/account/account_screen.dart';
import 'package:nurserygardenapp/view/screen/account/sub_screen/changes_password_screen.dart';
import 'package:nurserygardenapp/view/screen/account/sub_screen/profile_screen.dart';
import 'package:nurserygardenapp/view/screen/account/sub_screen/settings_screen.dart';
import 'package:nurserygardenapp/view/screen/auth/login_screen.dart';
import 'package:nurserygardenapp/view/screen/auth/register_screen.dart';
import 'package:nurserygardenapp/view/screen/bidding/bidding_screen.dart';
import 'package:nurserygardenapp/view/screen/dashboard/dashboard_screen.dart';
import 'package:nurserygardenapp/view/screen/home/home_screen.dart';
import 'package:nurserygardenapp/view/screen/plant/plant_detail_screen.dart';
import 'package:nurserygardenapp/view/screen/plant/plant_screen.dart';
import 'package:nurserygardenapp/view/screen/product/product_detail_screen.dart';
import 'package:nurserygardenapp/view/screen/product/product_screen.dart';
import 'package:nurserygardenapp/view/screen/splash/splash_screen.dart';

class RouterHelper {
  static final FluroRouter router = FluroRouter();

  static Handler _splashHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => SplashScreen());

  static Handler _loginHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> parameters) => LoginScreen());

  static Handler _registerHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> parameters) =>
          RegisterScreen());

  static Handler _dashboardHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          DashboardScreen(pageIndex: 0));

  // Selected  Certain Dashboard Screen
  static Handler _dashScreenBoardHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return DashboardScreen(
        pageIndex: params['page'][0] == 'Plant'
            ? 0
            : params['page'][0] == 'Product'
                ? 1
                : params['page'][0] == 'Bidding'
                    ? 2
                    : params['page'][0] == 'Account'
                        ? 3
                        : 0);
  });

  static Handler _homeHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> parameters) => HomeScreen(),
  );

  static Handler _plantHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> parameters) => PlantScreen(),
  );

  static Handler _plantDetailHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) =>
        PlantDetailScreen(plantID: params['plantID'][0]),
  );

  static Handler _productHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> parameters) => ProductScreen(),
  );

  static Handler _productDetailHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) =>
        ProductDetailScreen(productID: params['productID'][0]),
  );

  static Handler _biddingHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> parameters) => BiddingScreen(),
  );

  static Handler _accountHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> parameters) => AccountScreen(),
  );

  static Handler _profileHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> parameters) =>
        UserProfileScreen(),
  );

  static Handler _settingsHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> parameters) => SettingScreen(),
  );

  static Handler _changePasswordHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> parameters) =>
        ChangesPasswordScreen(),
  );

//*******Route Define*********
  static void setupRoute() {
    // router.define(Routes.DASHBOARD,
    //     handler: _dashboardHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.SPLASH_SCREEN,
        handler: _splashHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.LOGIN_SCREEN,
        handler: _loginHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.DASHBOARD,
        handler: _dashboardHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.REGISTER_SCREEN,
        handler: _registerHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.HOME_SCREEN,
        handler: _homeHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.PLANT_SCREEN,
        handler: _plantHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.PLANT_DETAIL_SCREEN,
        handler: _plantDetailHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.PRODUCT_SCREEN,
        handler: _productHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.PRODUCT_DETAIL_SCREEN,
        transitionType: TransitionType.fadeIn, handler: _productDetailHandler);
    router.define(Routes.BIDDING_SCREEN,
        handler: _biddingHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.ACCOUNT_SCREEN,
        handler: _accountHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.PROFILE_SCREEN,
        handler: _profileHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.SETTINGS_SCREEN,
        handler: _settingsHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.CHANGE_PASSWORD_SCREEN,
        handler: _changePasswordHandler, transitionType: TransitionType.fadeIn);
    // Selected Dashboard Screen
    router.define(Routes.DASHBOARD_SCREEN,
        handler: _dashScreenBoardHandler,
        transitionType: TransitionType.fadeIn);
  }
}
