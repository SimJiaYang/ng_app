import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nurserygardenapp/providers/auth_provider.dart';
import 'package:nurserygardenapp/providers/user_provider.dart';
import 'package:nurserygardenapp/util/app_constants.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
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
  late UserProvider user_prov =
      Provider.of<UserProvider>(context, listen: false);
  String imageUrl = "";
  String name = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      user_prov.getUserInfo();
      if (user_prov.userData.name == null) {
        _getUserInformation();
      } else {
        setState(() {
          imageUrl = user_prov.userData.image_url ?? Images.profile_header;
          name = user_prov.userData.name ?? "";
        });
      }
    });
  }

  Future<void> _getUserInformation() async {
    bool isSuccess = await user_prov.showUserInformation(context);
    if (isSuccess) {
      setState(() {
        imageUrl = user_prov.userData.image_url ?? Images.profile_header;
        name = user_prov.userData.name ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(5),
          color: ColorResources.COLOR_WHITE,
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                  child: Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      return userProvider.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, Routes.getProfileRoute());
                              },
                              child: Container(
                                color: Colors.white,
                                height: 80,
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipOval(
                                      child: SizedBox.fromSize(
                                          size: Size.fromRadius(
                                              30), // Image radius
                                          child: CachedNetworkImage(
                                            filterQuality: FilterQuality.low,
                                            imageUrl: imageUrl,
                                            memCacheHeight: 200,
                                            memCacheWidth: 200,
                                            placeholder: (context, url) =>
                                                Padding(
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                                        Images.profile_header,
                                                        fit: BoxFit.cover),
                                          )),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Center(
                                      child: Text(
                                        name,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
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
                  )),
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
