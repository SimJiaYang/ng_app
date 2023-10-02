import 'package:flutter/material.dart';
import 'package:nurserygardenapp/providers/user_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/dimensions.dart';
import 'package:nurserygardenapp/view/base/custom_appbar.dart';
import 'package:nurserygardenapp/view/base/custom_button.dart';
import 'package:nurserygardenapp/view/base/custom_snackbar.dart';
import 'package:nurserygardenapp/view/base/custom_textfield.dart';
import 'package:provider/provider.dart';

class ChangesPasswordScreen extends StatefulWidget {
  const ChangesPasswordScreen({super.key});

  @override
  State<ChangesPasswordScreen> createState() => _ChangesPasswordScreenState();
}

class _ChangesPasswordScreenState extends State<ChangesPasswordScreen> {
  FocusNode _oldPassword = FocusNode();
  FocusNode _newPassword = FocusNode();
  FocusNode _confirmPassword = FocusNode();
  late TextEditingController _oldPasswordController = TextEditingController();
  late TextEditingController _newPasswordController = TextEditingController();
  late TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        isBackButtonExist: false,
        title: "Change Password",
      ),
      body: SafeArea(
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Old Password",
                      style: TextStyle(
                        color: Color.fromRGBO(158, 161, 167, 0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    CustomTextField(
                      isPassword: true,
                      isShowBorder: true,
                      hintText: "Please enter password",
                      isShowSuffixIcon: true,
                      controller: _oldPasswordController,
                      focusNode: _oldPassword,
                      nextFocus: _newPassword,
                    ),
                  ]),
            ),
            SizedBox(height: 16),
            Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "New Password",
                      style: TextStyle(
                        color: Color.fromRGBO(158, 161, 167, 0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    CustomTextField(
                      isPassword: true,
                      isShowBorder: true,
                      hintText: "Please enter password",
                      controller: _newPasswordController,
                      focusNode: _newPassword,
                      nextFocus: _confirmPassword,
                      isShowSuffixIcon: true,
                    ),
                  ]),
            ),
            SizedBox(height: 16),
            Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Confirm Password",
                      style: TextStyle(
                        color: Color.fromRGBO(158, 161, 167, 0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    CustomTextField(
                      isPassword: true,
                      isShowBorder: true,
                      hintText: "Please confirm your password",
                      controller: _confirmPasswordController,
                      focusNode: _confirmPassword,
                      isShowSuffixIcon: true,
                    ),
                  ]),
            ),
            SizedBox(height: 16),
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                return userProvider.isUploading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ),
                      )
                    : CustomButton(
                        btnTxt: "Update",
                        onTap: () async {
                          if (userProvider.isUploading) return null;
                          // Save the new password
                          FocusScope.of(context).unfocus();
                          String old_pwd = _oldPasswordController.text;
                          String new_pwd = _newPasswordController.text;
                          String conf_password =
                              _confirmPasswordController.text;

                          if (old_pwd.isEmpty) {
                            showCustomSnackBar(
                                "Old Password is required", context);
                          } else if (new_pwd.isEmpty) {
                            showCustomSnackBar(
                                "New Password is required", context);
                          } else if (conf_password.isEmpty) {
                            showCustomSnackBar(
                                "Password Confirmation is required", context);
                          } else if (new_pwd != conf_password) {
                            showCustomSnackBar("Password not match", context);
                          } else if (new_pwd.length < 8 ||
                              old_pwd.length < 8 ||
                              conf_password.length < 8) {
                            showCustomSnackBar(
                                "Password length must not less than 8 words",
                                context);
                          } else {
                            bool isSuccessful = await userProvider
                                .updatePassword(context, old_pwd, new_pwd);
                            if (isSuccessful) {
                              Navigator.pop(context);
                            }
                          }
                        },
                      );
              },
            )
          ],
        ),
      )),
    );
  }
}
