import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nurserygardenapp/providers/auth_provider.dart';
import 'package:nurserygardenapp/providers/user_provider.dart';
import 'package:nurserygardenapp/util/app_constants.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/custom_text_style.dart';
import 'package:nurserygardenapp/util/images.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:provider/provider.dart';
import '../../base/custom_dialog.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late UserProvider user_prov;

  @override
  void initState() {
    super.initState();
    user_prov = Provider.of<UserProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      user_prov.getUserInfo();
      if (user_prov.userData.email == null) {
        _getUserInformation();
      }
      setState(() {});
    });
  }

  Future<void> _getUserInformation() async {
    await user_prov.showUserInformation(context);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.COLOR_PRIMARY,
        toolbarHeight: 100,
        title: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return userProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.getProfileRoute())
                          .then((value) => {
                                if (value == true) {_getUserInformation()}
                              });
                      ;
                    },
                    child: Container(
                      color: Colors.transparent,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(1), // Border width
                            decoration: BoxDecoration(
                                color: Colors.greenAccent.withOpacity(0.3),
                                shape: BoxShape.circle),
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                  size: Size.fromRadius(30), // Image radius
                                  child: userProvider.userData.image_url == null
                                      ? Image.asset(Images.profile_header,
                                          fit: BoxFit.cover)
                                      : CachedNetworkImage(
                                          filterQuality: FilterQuality.low,
                                          imageUrl:
                                              userProvider.userData.image_url!,
                                          memCacheHeight: 200,
                                          memCacheWidth: 200,
                                          placeholder: (context, url) =>
                                              Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(Images.profile_header,
                                                  fit: BoxFit.cover),
                                        )),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Center(
                            child: Text(
                              userProvider.userData.name ?? '',
                              style: CustomTextStyles(context)
                                  .titleStyle
                                  .copyWith(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                    ),
                  );
          },
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            // SizedBox(
            //   height: 5,
            // ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.getOrderRoute());
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: ColorResources.COLOR_GREY.withOpacity(0.3),
                  width: 0.5,
                ))),
                child: ListTile(
                  leading: Icon(
                    Icons.list_alt_outlined,
                    color: ColorResources.COLOR_BLACK,
                  ),
                  title: Text(
                    "Orders",
                    style: CustomTextStyles(context).titleStyle.copyWith(
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                        ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_outlined,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.getDeliveryRoute());
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: ColorResources.COLOR_GREY.withOpacity(0.3),
                  width: 0.5,
                ))),
                child: ListTile(
                  leading: Icon(
                    Icons.local_shipping_outlined,
                    color: ColorResources.COLOR_BLACK,
                  ),
                  title: Text(
                    "Delivery",
                    style: CustomTextStyles(context).titleStyle.copyWith(
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                        ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_outlined,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: ColorResources.COLOR_GREY.withOpacity(0.3),
                  width: 0.5,
                ))),
                child: ListTile(
                  leading: Icon(
                    Icons.favorite_border_outlined,
                    color: ColorResources.COLOR_BLACK,
                  ),
                  title: Text(
                    "Favourite List",
                    style: CustomTextStyles(context).titleStyle.copyWith(
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                        ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_outlined,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: ColorResources.COLOR_GREY.withOpacity(0.3),
                  width: 0.5,
                ))),
                child: ListTile(
                  leading: Icon(
                    Icons.money_off_csred_outlined,
                    color: ColorResources.COLOR_BLACK,
                  ),
                  title: Text(
                    "Bidding Refund",
                    style: CustomTextStyles(context).titleStyle.copyWith(
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                        ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_outlined,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.getSettingsRoute());
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: ColorResources.COLOR_GREY.withOpacity(0.3),
                  width: 0.5,
                ))),
                child: ListTile(
                  leading: Icon(
                    Icons.settings_outlined,
                    color: ColorResources.COLOR_BLACK,
                  ),
                  title: Text(
                    "Account Settings",
                    style: CustomTextStyles(context).titleStyle.copyWith(
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                        ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_outlined,
                  ),
                ),
              ),
            ),
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return GestureDetector(
                  onTap: () {
                    authProvider.isLoading
                        ? null
                        : showDialog(
                            context: context,
                            builder: (context) {
                              return CustomDialog(
                                dialogType: AppConstants.DIALOG_CONFIRMATION,
                                btnText: "Logout",
                                title: "Logout",
                                content: "Are you sure you want to logout?",
                                onPressed: () {
                                  if (authProvider.isLoading) {
                                    return;
                                  }

                                  authProvider.logout(context).then((value) {
                                    if (!value) {
                                      Navigator.pop(context);
                                    } else {
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          Routes.getLoginRoute(),
                                          (route) => false);
                                    }
                                  });
                                },
                              );
                            });
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: ColorResources.APPBAR_HEADER_COLOR,
                    ),
                    title: Text(
                      "Logout",
                      style: CustomTextStyles(context).titleStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: ColorResources.APPBAR_HEADER_COLOR,
                          ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 5,
            ),
            Text(AppConstants.APP_VERSION,
                textAlign: TextAlign.center,
                style: CustomTextStyles(context).titleStyle.copyWith(
                      color: Colors.black.withOpacity(0.3),
                    )),
          ],
        ),
      ),
    );
  }
}
