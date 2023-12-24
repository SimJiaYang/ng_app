import 'package:flutter/material.dart';
import 'package:nurserygardenapp/util/custom_text_style.dart';
import 'package:nurserygardenapp/view/base/custom_appbar.dart';

class FAQsScreen extends StatelessWidget {
  const FAQsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(
        title: 'FAQs',
        context: context,
        isBgPrimaryColor: true,
        isBackButtonExist: false,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Nursery Garden",
                  style: CustomTextStyles(context).titleStyle),
            ),
            FAQItem(icon: Icons.phone, title: "07-68632571"),
            FAQItem(icon: Icons.email, title: "nsg@gmail.com"),
            FAQItem(
                icon: Icons.location_on,
                title: "No 131A, Jalan Alasagoff, Pontian, Johor, Malaysia"),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Please dont hesitate to contact us if you have any questions.",
                style: CustomTextStyles(context)
                    .subTitleStyle
                    .copyWith(color: Colors.grey, fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final IconData icon;
  final String title;
  const FAQItem({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                  offset: Offset(0, 5))
            ]),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.black.withOpacity(0.75),
            ),
            SizedBox(width: 10),
            Flexible(
              child: Text(
                title,
                style: CustomTextStyles(context).subTitleStyle,
              ),
            )
          ],
        ),
      ),
    );
  }
}
