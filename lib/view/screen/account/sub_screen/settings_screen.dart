import 'package:flutter/material.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/dimensions.dart';
import 'package:nurserygardenapp/util/routes.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    TextStyle _title = theme.headlineMedium!.copyWith(
      fontSize: Dimensions.FONT_SIZE_DEFAULT,
      color: ColorResources.COLOR_BLACK.withOpacity(0.8),
    );
    TextStyle _subTitle = theme.headlineMedium!.copyWith(
      fontSize: Dimensions.FONT_SIZE_LARGE,
      fontWeight: FontWeight.w300,
      color: ColorResources.COLOR_BLACK.withOpacity(0.7),
    );

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Color.fromRGBO(255, 255, 255, 1), // <-- SEE HERE
        ),
        backgroundColor: ColorResources.COLOR_PRIMARY,
        title: Text(
          'Settings',
          style: theme.bodyLarge!.copyWith(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 10, bottom: 10),
              child: Text(
                "My Account",
                style: _subTitle,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.getChangePasswordRoute());
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
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
                    "Change Password",
                    style: _subTitle,
                  ),
                  trailing: Icon(
                    Icons.chevron_right_outlined,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.getChangeEmailRoute());
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(
                      color: ColorResources.COLOR_GREY.withOpacity(0.3),
                      width: 0.5,
                    ))),
                child: ListTile(
                  leading: Icon(
                    Icons.mark_email_read_outlined,
                    color: ColorResources.COLOR_BLACK,
                  ),
                  title: Text(
                    "Change Email",
                    style: _subTitle,
                  ),
                  trailing: Icon(
                    Icons.chevron_right_outlined,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.getAddressRoute());
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(
                      color: ColorResources.COLOR_GREY.withOpacity(0.3),
                      width: 0.5,
                    ))),
                child: ListTile(
                  leading: Icon(
                    Icons.location_on_outlined,
                    color: ColorResources.COLOR_BLACK,
                  ),
                  title: Text(
                    "My addresses",
                    style: _subTitle,
                  ),
                  trailing: Icon(
                    Icons.chevron_right_outlined,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
