import 'package:flutter/material.dart';
import 'package:nurserygardenapp/data/model/auth_model.dart';
import 'package:nurserygardenapp/providers/auth_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/custom_text_style.dart';
import 'package:nurserygardenapp/util/dimensions.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/base/custom_button.dart';
import 'package:nurserygardenapp/view/base/custom_snackbar.dart';
import 'package:nurserygardenapp/view/base/custom_space.dart';
import 'package:nurserygardenapp/view/base/custom_textfield.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  FocusNode _name = FocusNode();
  FocusNode _emailFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  FocusNode _confirmPasswordFocus = FocusNode();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  GlobalKey<FormState>? _formKeyLogin;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;

    return Scaffold(
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
                          builder: ((context, authProvider, child) => Form(
                                key: _formKeyLogin,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                        child: Text(
                                      'Register Account',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall!
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 24,
                                            color: Color.fromARGB(
                                                255, 30, 133, 104),
                                          ),
                                    )),
                                    SizedBox(height: 25),
                                    Text(
                                      "Name",
                                      style: TextStyle(
                                          color: ColorResources
                                              .COLOR_GREY_CHATEAU),
                                    ),
                                    VerticalSpacing(),
                                    CustomTextField(
                                      hintText: "Please enter your name",
                                      isShowBorder: true,
                                      isShowPrefixIcon: true,
                                      prefixIconUrl: Icon(
                                        Icons.perm_identity_rounded,
                                        color: Colors.grey,
                                      ),
                                      focusNode: _name,
                                      nextFocus: _emailFocus,
                                      controller: _nameController,
                                      inputType: TextInputType.text,
                                    ),
                                    VerticalSpacing(),
                                    Text(
                                      "Email",
                                      style: TextStyle(
                                          color: ColorResources
                                              .COLOR_GREY_CHATEAU),
                                    ),
                                    VerticalSpacing(),
                                    CustomTextField(
                                      hintText: "Please enter your email",
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
                                    VerticalSpacing(),
                                    Text(
                                      "Password",
                                      style: TextStyle(
                                          color: ColorResources
                                              .COLOR_GREY_CHATEAU),
                                    ),
                                    VerticalSpacing(),
                                    CustomTextField(
                                      hintText: "Please enter your password",
                                      isShowBorder: true,
                                      isPassword: true,
                                      isShowPrefixIcon: true,
                                      isShowSuffixIcon: true,
                                      prefixIconUrl: Icon(Icons.lock_outline),
                                      focusNode: _passwordFocus,
                                      nextFocus: _confirmPasswordFocus,
                                      controller: _passwordController,
                                      isPasswordValidator: true,
                                    ),
                                    VerticalSpacing(),
                                    Text(
                                      "Confirm Password",
                                      style: TextStyle(
                                          color: ColorResources
                                              .COLOR_GREY_CHATEAU),
                                    ),
                                    VerticalSpacing(),
                                    CustomTextField(
                                      hintText: 'Please confirm your password',
                                      isShowBorder: true,
                                      isPassword: true,
                                      isShowPrefixIcon: true,
                                      isShowSuffixIcon: true,
                                      prefixIconUrl: Icon(Icons.lock_outline),
                                      focusNode: _confirmPasswordFocus,
                                      controller: _confirmPasswordController,
                                      inputAction: TextInputAction.done,
                                    ),
                                    VerticalSpacing(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                            child: Text(
                                          "* Please note that according to PDPA, we will only use your personal data for business purpose.",
                                          style: CustomTextStyles(context)
                                              .subTitleStyle
                                              .copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_SMALL,
                                                  color: ColorResources
                                                      .COLOR_GRAY),
                                        )),
                                      ],
                                    ),
                                    VerticalSpacing(
                                      height: 3,
                                    ),
                                    !authProvider.isLoading
                                        ? CustomButton(
                                            btnTxt: "Register",
                                            onTap: () {
                                              String _name =
                                                  _nameController.text.trim();
                                              String _email =
                                                  _emailController.text.trim();
                                              String _password =
                                                  _passwordController.text
                                                      .trim();
                                              String _confirmPassword =
                                                  _confirmPasswordController
                                                      .text
                                                      .trim();
                                              bool isValidated = _formKeyLogin!
                                                  .currentState!
                                                  .validate();
                                              if (isValidated) {
                                                if (_confirmPassword !=
                                                    _password) {
                                                  showCustomSnackBar(
                                                      "Password does not match",
                                                      context);
                                                } else {
                                                  AuthModel userModel =
                                                      AuthModel(
                                                          email: _email,
                                                          name: _name,
                                                          password: _password);
                                                  authProvider
                                                      .registration(
                                                          userModel, context)
                                                      .then((value) {
                                                    if (value) {
                                                      authProvider
                                                          .login(
                                                              _email,
                                                              _password,
                                                              context)
                                                          .then((value) {
                                                        if (value) {
                                                          Navigator
                                                              .pushNamedAndRemoveUntil(
                                                                  context,
                                                                  Routes
                                                                      .getMainRoute(),
                                                                  (route) =>
                                                                      false);
                                                        }
                                                      });
                                                    }
                                                  });
                                                }
                                              }
                                            },
                                          )
                                        : Center(
                                            child: CircularProgressIndicator(
                                            valueColor:
                                                new AlwaysStoppedAnimation<
                                                        Color>(
                                                    Theme.of(context)
                                                        .primaryColor),
                                          )),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            // for create an account
            Expanded(
              flex: 1,
              child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                return InkWell(
                  onTap: () {
                    if (authProvider.isLoading) {
                      return;
                    } else {
                      Navigator.pushNamed(context, Routes.getLoginRoute());
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have account?',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  fontSize: Dimensions.FONT_SIZE_SMALL,
                                  color: ColorResources.COLOR_GREY_CHATEAU),
                        ),
                        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                        Text(
                          'Login',
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
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
