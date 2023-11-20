class Routes {
  /** ROUTE NAME **/
  static const String COMING_SOON = '/coming-soon';
  static const String SPLASH_SCREEN = '/splash';

  // Auth
  static const String LOGIN_SCREEN = '/login';
  static const String REGISTER_SCREEN = '/register';

  // Dashboard
  static const String DASHBOARD = '/';
  static const String HOME_SCREEN = '/home';
  static const String DASHBOARD_SCREEN = '/dashboard';

  // Plant
  static const String PLANT_SCREEN = '/plant';
  static const String PLANT_DETAIL_SCREEN = '/plant-detail';
  static const String PLANT_SEARCH_SCREEN = '/plant-search';
  static const String PLANT_SEARCH_RESULT_SCREEN = '/plant-search/result';

  // Product
  static const String PRODUCT_SCREEN = '/product';
  static const String PRODUCT_DETAIL_SCREEN = '/product-detail';
  static const String PRODUCT_SEARCH_SCREEN = '/product-search';
  static const String PRODUCT_SEARCH_RESULT_SCREEN = '/product-search/result';

  // Cart
  static const String CART_SCREEN = '/cart';

  // Order
  static const String ORDER_SCREEN = '/order';
  static const String ORDER_DETAIL_SCREEN = '/order-detail';
  static const String ORDER_CONFIRMATION_SCREEN = '/order-confirmation';
  static const String ORDER_ADDRESS_SCREEN = '/order-address';
  static const String ORDER_DELIVERY_SCREEN = '/order-delivery';

  // Payment
  static const String PAYMENT_SCREEN = '/payment';

  // Address
  static const String ADDRESS_SCREEN = '/address';
  static const String ADD_ADDRESS_SCREEN = '/add-address';
  static const String ADDRESS_DETAIL_SCREEN = '/address-detail';

  // Bidding
  static const String BIDDING_SCREEN = '/bidding';

  // Delivery
  static const String DELIVERY_SCREEN = '/delivery';
  static const String DELIVERY_DETAIL_SCREEN = '/delivery-detail';
  static const String DELIVERY_RECEIPT_SCREEN = '/delivery-receipt';

  // Account
  static const String ACCOUNT_SCREEN = '/account';
  static const String PROFILE_SCREEN = '/profile';
  static const String SETTINGS_SCREEN = '/settings';
  static const String CHANGE_PASSWORD_SCREEN = '/change-password';
  static const String CHANGE_EMAIL = '/change-email';

  // Image Widget
  static const String IMAGE_ENLARGE_SCREEN = '/image-enlarge';

  /** ROUTE **/
  static String getComingSoonRoute() => COMING_SOON;
  static String getSplashRoute() => SPLASH_SCREEN;

  // Auth
  static String getLoginRoute() => LOGIN_SCREEN;
  static String getRegisterRoute() => REGISTER_SCREEN;

  // Dashboard
  static String getHomeRoute() => HOME_SCREEN;
  static String getMainRoute() => DASHBOARD;
  static String getDashboardRoute(String page) =>
      '$DASHBOARD_SCREEN?page=$page';

  // Plant
  static String getPlantRoute() => PLANT_SCREEN;
  static String getPlantDetailRoute(
          String plantID, String isSearch, String isCart) =>
      '$PLANT_DETAIL_SCREEN?plantID=$plantID&isSearch=$isSearch&isCart=$isCart';
  static String getPlantSearchRoute() => PLANT_SEARCH_SCREEN;
  static String getPlantSearchResultRoute(String searchKeyword) =>
      '$PLANT_SEARCH_RESULT_SCREEN?searchKeyword=$searchKeyword';

  // Product
  static String getProductRoute() => PRODUCT_SCREEN;
  static String getProductDetailRoute(
          String productID, String isSearch, String isCart) =>
      '$PRODUCT_DETAIL_SCREEN?productID=$productID&isSearch=$isSearch&isCart=$isCart';
  static String getProductSearchRoute() => PRODUCT_SEARCH_SCREEN;
  static String getProductSearchResultRoute(String searchKeyword) =>
      '$PRODUCT_SEARCH_RESULT_SCREEN?searchKeyword=$searchKeyword';

  // Cart
  static String getCartRoute() => CART_SCREEN;

  // Order
  static String getOrderRoute() => ORDER_SCREEN;
  static String getOrderDetailRoute(String orderID) =>
      '$ORDER_DETAIL_SCREEN?orderID=$orderID';
  static String getOrderConfirmationRoute() => ORDER_CONFIRMATION_SCREEN;
  static String getOrderAddressRoute() => ORDER_ADDRESS_SCREEN;
  static String getOrderDeliveryRoute(String orderID) =>
      '$ORDER_DELIVERY_SCREEN?orderID=$orderID';

  // Payment
  static String getPaymentRoute(String paymentType, String orderID) =>
      '$PAYMENT_SCREEN?paymentType=$paymentType&orderID=$orderID';

  // Address
  static String getAddressRoute() => ADDRESS_SCREEN;
  static String getAddressDetailRoute(String addressID) =>
      '$ADDRESS_DETAIL_SCREEN?addressID=$addressID';
  static String getAddAddressRoute() => ADD_ADDRESS_SCREEN;

  // Delivery
  static String getDeliveryRoute() => DELIVERY_SCREEN;
  static String getDeliveryDetailRoute(String deliveryID) =>
      '$DELIVERY_DETAIL_SCREEN?deliveryID=$deliveryID';
  static String getDeliveryReceiptRoute(String deliveryID) =>
      '$DELIVERY_RECEIPT_SCREEN?deliveryID=$deliveryID';

  // Bidding
  static String getBiddingRoute() => BIDDING_SCREEN;

  // Image widget
  static String getImageEnlargeRoute(String tag, String url) =>
      '$IMAGE_ENLARGE_SCREEN?tag=$tag&url=$url';

  // Account
  static String getAcocuntRoute() => ACCOUNT_SCREEN;
  static String getProfileRoute() => PROFILE_SCREEN;
  static String getSettingsRoute() => SETTINGS_SCREEN;
  static String getChangePasswordRoute() => CHANGE_PASSWORD_SCREEN;
  static String getChangeEmailRoute() => CHANGE_EMAIL;
}
