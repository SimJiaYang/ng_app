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
    // _checkToken();
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
                                    label: 'Email',
                                    hintText: 'examle@mail.com',
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
                                    isApplyValidator: true,
                                  ),
                                  SizedBox(
                                      height: Dimensions.PADDING_SIZE_SMALL),
                                  CustomTextField(
                                    label: 'Password',
                                    hintText: '*******',
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
                                    isPasswordValidator: true,
                                  ),
                                  SizedBox(height: 22),

                                  // for login button
                                  SizedBox(height: 10),
                                  !authProvider.isLoading
                                      ? CustomButton(
                                          btnTxt: 'Login',
                                          onTap: () async {
                                            String _email =
                                                _emailController.text.trim();
                                            String _password =
                                                _passwordController.text.trim();
                                            FocusScope.of(context).unfocus();
                                            bool isValidated = _formKeyLogin!
                                                .currentState!
                                                .validate();
                                            if (isValidated) {
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
