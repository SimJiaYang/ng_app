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
    if (context.mounted) {
      await user_prov.showUserInformation(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
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
                                        context, Routes.getProfileRoute())
                                    .then((value) => {
                                          if (value == true)
                                            {_getUserInformation()}
                                        });
                                ;
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
                                          child: userProvider
                                                      .userData.image_url ==
                                                  null
                                              ? Image.asset(
                                                  Images.profile_header,
                                                  fit: BoxFit.cover)
                                              : CachedNetworkImage(
                                                  filterQuality:
                                                      FilterQuality.low,
                                                  imageUrl: userProvider
                                                      .userData.image_url!,
                                                  memCacheHeight: 200,
                                                  memCacheWidth: 200,
                                                  placeholder: (context, url) =>
                                                      Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            1.0),
                                                    child: Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
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
                                        userProvider.userData.name ?? '',
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
