import 'package:flutter/material.dart';
import 'package:nurserygardenapp/providers/user_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/dimensions.dart';
import 'package:nurserygardenapp/view/base/circular_indicator.dart';
import 'package:nurserygardenapp/view/base/custom_appbar.dart';
import 'package:nurserygardenapp/view/base/custom_button.dart';
import 'package:nurserygardenapp/view/base/custom_textfield.dart';
import 'package:provider/provider.dart';

class ChangesEmailScreen extends StatefulWidget {
  const ChangesEmailScreen({super.key});

  @override
  State<ChangesEmailScreen> createState() => _ChangesEmailScreenState();
}

class _ChangesEmailScreenState extends State<ChangesEmailScreen> {
  late UserProvider user_prov =
      Provider.of<UserProvider>(context, listen: false);
  TextEditingController _oldEmailController = TextEditingController();
  TextEditingController _newEmailController = TextEditingController();
  FocusNode _oldEmail = FocusNode();
  FocusNode _newEmail = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      user_prov.getUserInfo();
      if (user_prov.userData.email == null) {
        _getUserInformation();
      }
      setState(() {
        _oldEmailController.text = user_prov.userData.email!;
      });
    });
  }

  Future<bool> _getUserInformation() async {
    return await user_prov.showUserInformation(context);
  }

  @override
  void dispose() {
    super.dispose();
    _oldEmailController.dispose();
    _newEmailController.dispose();
    _oldEmail.dispose();
    _newEmail.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    TextStyle _subTitle = theme.headlineMedium!.copyWith(
      fontSize: Dimensions.FONT_SIZE_DEFAULT,
      fontWeight: FontWeight.w300,
      color: ColorResources.COLOR_BLACK.withOpacity(0.7),
    );

    return Scaffold(
      appBar: CustomAppBar(
        isBgPrimaryColor: true,
        isCenter: false,
        context: context,
        isBackButtonExist: false,
        title: "Change Email",
      ),
      body: Consumer<UserProvider>(builder: (context, userProvider, child) {
        return userProvider.isLoading
            ? CircularProgress()
            : SafeArea(
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
                              "Old Email",
                              style: TextStyle(
                                color: Color.fromRGBO(158, 161, 167, 0.8),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            CustomTextField(
                              isReadOnly: true,
                              hintText: "Your email",
                              isShowBorder: true,
                              isShowPrefixIcon: true,
                              prefixIconUrl: Icon(
                                Icons.email_outlined,
                                color: Colors.grey,
                              ),
                              inputType: TextInputType.emailAddress,
                              controller: _oldEmailController,
                              focusNode: _oldEmail,
                              nextFocus: _newEmail,
                            )
                          ]),
                    ),
                    SizedBox(height: 16),
                    Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "New Email",
                              style: TextStyle(
                                color: Color.fromRGBO(158, 161, 167, 0.8),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            CustomTextField(
                              hintText: "Please enter your new email",
                              isShowBorder: true,
                              isShowPrefixIcon: true,
                              prefixIconUrl: Icon(
                                Icons.email_outlined,
                                color: Colors.grey,
                              ),
                              inputType: TextInputType.emailAddress,
                              controller: _newEmailController,
                              focusNode: _newEmail,
                              inputAction: TextInputAction.done,
                            ),
                          ]),
                    ),
                    SizedBox(height: 16),
                    Consumer<UserProvider>(
                      builder: (context, userProvider, child) {
                        return CustomButton(
                          btnTxt: "Update",
                          onTap: () async {},
                        );
                      },
                    )
                  ],
                ),
              ));
      }),
    );
  }
}
