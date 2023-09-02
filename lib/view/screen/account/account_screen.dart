import 'package:flutter/material.dart';
import 'package:nurserygardenapp/providers/auth_provider.dart';
import 'package:nurserygardenapp/util/app_constants.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/drawer/drawer_widget.dart';
import 'package:provider/provider.dart';
import '../../base/custom_dialog.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
      ),
      drawer: DrawerWidget(size: size),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(5),
          color: ColorResources.COLOR_WHITE,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Routes.getProfileRoute());
                },
                child: ListTile(
                  leading: Icon(
                    Icons.badge_outlined,
                    color: ColorResources.COLOR_BLACK,
                  ),
                  title: Text(
                    "Profile",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: ColorResources.COLOR_BLACK,
                        ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_outlined,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: ListTile(
                  leading: Icon(
                    Icons.list_alt_outlined,
                    color: ColorResources.COLOR_BLACK,
                  ),
                  title: Text(
                    "Orders",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: ColorResources.COLOR_BLACK,
                        ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_outlined,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: ListTile(
                  leading: Icon(
                    Icons.local_shipping_outlined,
                    color: ColorResources.COLOR_BLACK,
                  ),
                  title: Text(
                    "Delivery",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: ColorResources.COLOR_BLACK,
                        ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_outlined,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: ListTile(
                  leading: Icon(
                    Icons.money_off_csred_outlined,
                    color: ColorResources.COLOR_BLACK,
                  ),
                  title: Text(
                    "Bidding Refund",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: ColorResources.COLOR_BLACK,
                        ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_outlined,
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
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: ColorResources.APPBAR_HEADER_COLOR,
                                ),
                      ),
                    ),
                  );
                },
              ),
              Text(
                AppConstants.APP_VERSION,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontSize: 15,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
