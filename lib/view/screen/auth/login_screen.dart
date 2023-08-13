import 'package:flutter/material.dart';
import 'package:nurserygardenapp/providers/auth_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/dimensions.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/base/custom_button.dart';
import 'package:nurserygardenapp/view/base/custom_snackbar.dart';
import 'package:nurserygardenapp/view/base/custom_textfield.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode _emailFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  GlobalKey<FormState>? _formKeyLogin;
  bool rememberMe = false;

  // Provider

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _checkToken();
  }

  void _checkToken() {
    Provider.of<AuthProvider>(context, listen: false)
        .checkUserLogin()
        .then((value) => {
              if (value)
                {
                  Navigator.pushNamedAndRemoveUntil(
                      context, Routes.getMainRoute(), (route) => false)
                }
            });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                      child: Center(
                        child: Container(
                          width: _width > 700 ? 700 : _width,
                          padding: _width > 700
                              ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
                              : null,
                          decoration: _width > 700
                              ? BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade300,
                                        blurRadius: 5,
                                        spreadRadius: 1)
                                  ],
                                )
                              : null,
                          child: Consumer<AuthProvider>(
                            builder: (context, authProvider, child) => Form(
                              key: _formKeyLogin,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text('Login',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(
                                              fontSize: 24,
                                              color: ColorResources
                                                  .COLOR_GREY_CHATEAU,
                                            )),
                                  ),
                                  SizedBox(height: 25),
                                  SizedBox(
                                      height: Dimensions.PADDING_SIZE_SMALL),
                                  CustomTextField(
                                    label: 'email',
                                    hintText: 'demo_gmail',
                                    isShowBorder: true,
                                    isShowPrefixIcon: true,
                                    prefixIconUrl: Icon(
                                      Icons.email_outlined,
                                      color: Colors.grey,
                                    ),
                                    focusNode: _emailFocus,
                                    nextFocus: _passwordFocus,
                                    controller: _emailController,
                                    inputType: TextInputType.emailAddress,
                                  ),
                                  SizedBox(
                                      height: Dimensions.PADDING_SIZE_SMALL),
                                  CustomTextField(
                                    label: 'password',
                                    hintText: 'password_hint',
                                    isShowBorder: true,
                                    isPassword: true,
                                    isShowPrefixIcon: true,
                                    isShowSuffixIcon: true,
                                    prefixIconUrl: Icon(
                                      Icons.lock_outline,
                                      color: Colors.grey,
                                    ),
                                    focusNode: _passwordFocus,
                                    controller: _passwordController,
                                    inputAction: TextInputAction.done,
                                  ),
                                  SizedBox(height: 22),

                                  // for login button
                                  SizedBox(height: 10),
                                  !authProvider.isLoading
                                      ? CustomButton(
                                          btnTxt: 'login',
                                          onTap: () async {
                                            String _email =
                                                _emailController.text.trim();
                                            String _password =
                                                _passwordController.text.trim();
                                            if (_email.isEmpty) {
                                              showCustomSnackBar(
                                                  "email is_required", context);
                                            } else if (_password.isEmpty) {
                                              showCustomSnackBar(
                                                  'enter_password', context);
                                            } else if (_password.length < 6) {
                                              showCustomSnackBar(
                                                  'password_should_be',
                                                  context);
                                            } else {
                                              FocusScope.of(context).unfocus();

                                              bool wait =
                                                  await authProvider.login(
                                                      _email,
                                                      _password,
                                                      context);

                                              if (wait) {
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                        context,
                                                        Routes.getMainRoute(),
                                                        (route) => false);
                                              }
                                            }
                                          },
                                        )
                                      : Center(
                                          child: CircularProgressIndicator(
                                          valueColor:
                                              new AlwaysStoppedAnimation<Color>(
                                                  Theme.of(context)
                                                      .primaryColor),
                                        )),

                                  // for social login
                                  SizedBox(height: 10),
                                  Container(
                                    height: 20,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: Divider(
                                            color: ColorResources.COLOR_GRAY,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'or',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: ColorResources.COLOR_GRAY,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Divider(
                                            color: ColorResources.COLOR_GRAY,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // for create an account
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    // Navigator.pushNamed(context, Routes.getSignUpRoute());
                  },
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'create_an_account',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  fontSize: Dimensions.FONT_SIZE_SMALL,
                                  color: ColorResources.COLOR_GREY),
                        ),
                        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                        Text(
                          'signup',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                  fontSize: Dimensions.FONT_SIZE_SMALL,
                                  color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // if (ResponsiveHelper.isDesktop(context)) FooterView(),
            ],
          ),
        ),
      ),
    );
  }
}
