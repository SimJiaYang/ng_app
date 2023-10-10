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

  // Product
  static const String PRODUCT_SCREEN = '/product';
  static const String PRODUCT_DETAIL_SCREEN = '/product-detail';

  // Bidding
  static const String BIDDING_SCREEN = '/bidding';

  // Account
  static const String ACCOUNT_SCREEN = '/account';
  static const String PROFILE_SCREEN = '/profile';
  static const String SETTINGS_SCREEN = '/settings';
  static const String CHANGE_PASSWORD_SCREEN = '/change-password';
  static const String CHANGE_EMAIL = '/change-email';

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
  static String getPlantDetailRoute(String plantID) =>
      '$PLANT_DETAIL_SCREEN?plantID=$plantID';
  static String getPlantSearchRoute() => PLANT_SEARCH_SCREEN;

  // Product
  static String getProductRoute() => PRODUCT_SCREEN;
  static String getProductDetailRoute(String productID) =>
      '$PRODUCT_DETAIL_SCREEN?productID=$productID';

  // Bidding
  static String getBiddingRoute() => BIDDING_SCREEN;

  // Account
  static String getAcocuntRoute() => ACCOUNT_SCREEN;
  static String getProfileRoute() => PROFILE_SCREEN;
  static String getSettingsRoute() => SETTINGS_SCREEN;
  static String getChangePasswordRoute() => CHANGE_PASSWORD_SCREEN;
  static String getChangeEmailRoute() => CHANGE_EMAIL;
}
