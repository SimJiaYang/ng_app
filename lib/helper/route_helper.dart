// import 'dart:ffi';

import 'package:fluro/fluro.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/screen/account/account_screen.dart';
import 'package:nurserygardenapp/view/screen/account/sub_screen/changes_email_screen.dart';
import 'package:nurserygardenapp/view/screen/account/sub_screen/changes_password_screen.dart';
import 'package:nurserygardenapp/view/screen/account/sub_screen/profile_screen.dart';
import 'package:nurserygardenapp/view/screen/account/sub_screen/settings_screen.dart';
import 'package:nurserygardenapp/view/screen/address/address_screen.dart';
import 'package:nurserygardenapp/view/screen/address/sub_screen/add_address_screen.dart';
import 'package:nurserygardenapp/view/screen/address/sub_screen/address_detail_screen.dart';
import 'package:nurserygardenapp/view/screen/auth/login_screen.dart';
import 'package:nurserygardenapp/view/screen/auth/register_screen.dart';
import 'package:nurserygardenapp/view/screen/bidding/bidding_screen.dart';
import 'package:nurserygardenapp/view/screen/cart/cart_screen.dart';
import 'package:nurserygardenapp/view/screen/dashboard/dashboard_screen.dart';
import 'package:nurserygardenapp/view/screen/home/home_screen.dart';
import 'package:nurserygardenapp/view/screen/order/order_screen.dart';
import 'package:nurserygardenapp/view/screen/order/sub_screen/order_confirmation_screen.dart';
import 'package:nurserygardenapp/view/screen/order/sub_screen/order_detail_screen.dart';
import 'package:nurserygardenapp/view/screen/payment/payment_screen.dart';
import 'package:nurserygardenapp/view/screen/plant/plant_detail_screen.dart';
import 'package:nurserygardenapp/view/screen/plant/plant_screen.dart';
import 'package:nurserygardenapp/view/screen/plant/plant_search_result_screen.dart';
import 'package:nurserygardenapp/view/screen/plant/widget/plant_search_screen.dart';
import 'package:nurserygardenapp/view/screen/product/product_detail_screen.dart';
import 'package:nurserygardenapp/view/screen/product/product_screen.dart';
import 'package:nurserygardenapp/view/screen/product/product_search_result_screen.dart';
import 'package:nurserygardenapp/view/screen/product/widget/product_search_screen.dart';
import 'package:nurserygardenapp/view/screen/splash/splash_screen.dart';

class RouterHelper {
  static final FluroRouter router = FluroRouter();

  static Handler _splashHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => SplashScreen());

  /// =================================Auth=========================================
  static Handler _loginHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> parameters) => LoginScreen());

  static Handler _registerHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> parameters) =>
          RegisterScreen());

  static Handler _dashboardHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          DashboardScreen(pageIndex: 0));

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

  // =================================Plant=========================================
  static Handler _plantHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> parameters) => PlantScreen(),
  );

  static Handler _plantDetailHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => PlantDetailScreen(
      plantID: params['plantID'][0],
      isSearch: params['isSearch'][0],
      isCart: params['isCart'][0],
    ),
  );

  static Handler _plantSearchHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> parameters) =>
        PlantSearchScreen(),
  );

  static Handler _plantSearchResultHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> parameters) =>
        PlantSearchResultScreen(searchKeyword: parameters['searchKeyword'][0]),
  );

  // =================================Product=========================================
  static Handler _productHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> parameters) => ProductScreen(),
  );

  static Handler _productDetailHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => ProductDetailScreen(
      productID: params['productID'][0],
      isSearch: params['isSearch'][0],
      isCart: params['isCart'][0],
    ),
  );

  static Handler _productSearchHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> parameters) =>
        ProductSearchScreen(),
  );

  static Handler _productSearchResultHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> parameters) =>
        ProductSearchResultScreen(
            searchKeyword: parameters['searchKeyword'][0]),
  );

  // =================================Cart=========================================
  static Handler _cartHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> parameters) => CartScreen(),
  );

  // =================================Order=========================================
  static Handler _orderHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> parameters) => OrderScreen(),
  );

  static Handler _orderDetailHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> parameters) =>
        OrderDetailScreen(
      orderID: parameters['orderID'][0],
    ),
  );

  static Handler _orderConfirmationHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> parameters) =>
        OrderConfirmationScreen(),
  );

  // =================================Payment=========================================
  static Handler _paymentHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> parameters) => PaymentScreen(
      paymentType: parameters['paymentType'][0],
      orderID: parameters['orderID'][0],
    ),
  );

  // =================================Bidding=========================================
  static Handler _biddingHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> parameters) => BiddingScreen(),
  );

  // =================================Account=========================================
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

  static Handler _addressHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> parameters) => AddressScreen(),
  );

  static Handler _addressDetailHanlder = Handler(
    handlerFunc: (context, Map<String, dynamic> parameters) =>
        AddressDetailScreen(
      addressID: parameters['addressID'][0],
    ),
  );

  static Handler _addAddressHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> parameters) =>
        AddAddressScreen(),
  );

  static Handler _changePasswordHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> parameters) =>
        ChangesPasswordScreen(),
  );

  static Handler _changeEmailHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> parameters) =>
        ChangesEmailScreen(),
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
    router.define(Routes.PLANT_SEARCH_SCREEN,
        transitionType: TransitionType.fadeIn, handler: _plantSearchHandler);
    router.define(Routes.PLANT_SEARCH_RESULT_SCREEN,
        transitionType: TransitionType.fadeIn,
        handler: _plantSearchResultHandler);
    router.define(Routes.PRODUCT_SCREEN,
        handler: _productHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.PRODUCT_DETAIL_SCREEN,
        transitionType: TransitionType.fadeIn, handler: _productDetailHandler);
    router.define(Routes.PRODUCT_SEARCH_SCREEN,
        transitionType: TransitionType.fadeIn, handler: _productSearchHandler);
    router.define(Routes.PRODUCT_SEARCH_RESULT_SCREEN,
        handler: _productSearchResultHandler,
        transitionType: TransitionType.fadeIn);
    router.define(Routes.CART_SCREEN,
        transitionType: TransitionType.fadeIn, handler: _cartHandler);
    router.define(Routes.ORDER_SCREEN,
        handler: _orderHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.ORDER_DETAIL_SCREEN,
        handler: _orderDetailHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.ORDER_CONFIRMATION_SCREEN,
        handler: _orderConfirmationHandler,
        transitionType: TransitionType.fadeIn);
    router.define(Routes.PAYMENT_SCREEN,
        handler: _paymentHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.ADDRESS_SCREEN,
        handler: _addressHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.ADDRESS_DETAIL_SCREEN,
        handler: _addressDetailHanlder, transitionType: TransitionType.fadeIn);
    router.define(Routes.ADD_ADDRESS_SCREEN,
        handler: _addAddressHandler, transitionType: TransitionType.fadeIn);
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
    router.define(Routes.CHANGE_EMAIL,
        handler: _changeEmailHandler, transitionType: TransitionType.fadeIn);
    // Selected Dashboard Screen
    router.define(Routes.DASHBOARD_SCREEN,
        handler: _dashScreenBoardHandler,
        transitionType: TransitionType.fadeIn);
  }
}
