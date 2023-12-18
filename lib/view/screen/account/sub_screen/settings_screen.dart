import 'package:flutter/material.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/custom_text_style.dart';
import 'package:nurserygardenapp/util/routes.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Color.fromRGBO(255, 255, 255, 1), // <-- SEE HERE
        ),
        backgroundColor: ColorResources.COLOR_PRIMARY,
        title: Text(
          'Settings',
          style: CustomTextStyles(context).subTitleStyle.copyWith(
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
                style: CustomTextStyles(context).subTitleStyle,
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
                  title: Text("Change Password",
                      style: CustomTextStyles(context)
                          .subTitleStyle
                          .copyWith(fontSize: 16)),
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
                    style: CustomTextStyles(context)
                        .subTitleStyle
                        .copyWith(fontSize: 16),
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
                    style: CustomTextStyles(context)
                        .subTitleStyle
                        .copyWith(fontSize: 16),
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
