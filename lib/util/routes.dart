class Routes {
  /** ROUTE NAME **/
  static const String COMING_SOON = '/coming-soon';
  static const String SPLASH_SCREEN = '/splash';

  // Auth
  static const String LOGIN_SCREEN = '/login';
  static const String REGISTER_SCREEN = '/register';

  // Dashboard
  static const String DASHBOARD = '/';
  static const String DASHBOARD_SCREEN = '/main';
  static const String HOME_SCREEN = '/home';

  // Account
  static const String ACCOUNT_SCREEN = '/account';
  static const String PROFILE_SCREEN = '/profile';

  /** ROUTE **/
  static String getComingSoonRoute() => COMING_SOON;
  static String getSplashRoute() => SPLASH_SCREEN;

  // Auth
  static String getLoginRoute() => LOGIN_SCREEN;
  static String getRegisterRoute() => REGISTER_SCREEN;

  // Dashboard
  static String getHomeRoute() => HOME_SCREEN;
  static String getMainRoute() => DASHBOARD;

  // Account
  static String getAcocuntRoute() => ACCOUNT_SCREEN;
  static String getProfileRoute() => PROFILE_SCREEN;
}
