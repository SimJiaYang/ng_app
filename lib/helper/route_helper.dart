// import 'dart:ffi';

import 'package:fluro/fluro.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/screen/auth/login_screen.dart';
import 'package:nurserygardenapp/view/screen/dashboard/dashboard_screen.dart';
import 'package:nurserygardenapp/view/screen/splash/splash_screen.dart';

class RouterHelper {
  static final FluroRouter router = FluroRouter();
  // static Handler _deshboardHandler = Handler(
  //     handlerFunc: (context, Map<String, dynamic> params) =>
  //         DashboardScreen(pageIndex: 0));

  // static Handler _onbordingHandler = Handler(
  //     handlerFunc: (context, Map<String, dynamic> params) =>
  //         OnBoardingScreen());

  // static Handler _dashboardHandler =
  //     Handler(handlerFunc: (context, Map<String, dynamic> params) {
  //   return DashboardScreen(
  //     pageIndex: 0,
  //   );
  // });

  static Handler _splashHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => SplashScreen());

  static Handler _loginHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> parameters) => LoginScreen());

  static Handler _dashboardHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          DashboardScreen(pageIndex: 0));

  // static Handler _homeHandler = Handler(
  //   handlerFunc: (context, Map<String, dynamic> parameters) => HomeScreen(),
  // );

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
    //   router.define(Routes.SIGNUP_SCREEN,
    //       handler: _signupHandler, transitionType: TransitionType.fadeIn);
    //   router.define(Routes.HOME_SCREEN,
    //       handler: _homeHandler, transitionType: TransitionType.fadeIn);
    //   router.define(Routes.DASHBOARD_SCREEN,
    //       handler: _dashScreenBoardHandler,
    //       transitionType: TransitionType.fadeIn);
    // }
  }
}
