import 'package:flutter/material.dart';
import 'package:nurserygardenapp/util/custom_text_style.dart';
import 'package:nurserygardenapp/view/base/custom_appbar.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Help',
        context: context,
        isBackButtonExist: false,
        isBgPrimaryColor: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          width: size.width,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              HelpContainer(
                  title: "When the bidding will be refund?",
                  des:
                      "The bidding will be refund in 5 days from the bidding time."),
              HelpContainer(
                  title: "Can I cancel an order?",
                  des:
                      "Yes, you can cancel an order before you pay. To cancel an order, please go to Orders, select the To Pay, and click Cancel Order."),
              HelpContainer(
                  title: "Can I cancel an bidding?",
                  des:
                      "Yes, you can cancel an bidding before you pa. Since you paid, you are not able to cancel the bidding."),
              HelpContainer(
                  title: "Can I change an order address?",
                  des:
                      "Yes, you can change an order address before your order shipped. To change an order address, please go to Orders, select the To Ship, and click Change Address."),
              HelpContainer(
                  title: "How can I track my order?",
                  des:
                      "You can track your order in Orders and Delivery page. If you have any questions, please contact us."),
              HelpContainer(
                  title: "Can I get my order receipt?",
                  des:
                      "Yes, you can get your order receipt in since order has been delivered. If you have any questions, please contact us."),
            ],
          ),
        ),
      ),
    );
  }
}

class HelpContainer extends StatelessWidget {
  final String title;
  final String des;
  const HelpContainer({super.key, required this.title, required this.des});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.2),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: CustomTextStyles(context).titleStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 10),
          Text(
            des,
            style: CustomTextStyles(context).subTitleStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
