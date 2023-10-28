import 'package:flutter/material.dart';
import 'package:nurserygardenapp/view/screen/cart/widget/empty_cart_item.dart';

class EmptyOrderDetail extends StatefulWidget {
  const EmptyOrderDetail({super.key});

  @override
  State<EmptyOrderDetail> createState() => _EmptyOrderDetailState();
}

class _EmptyOrderDetailState extends State<EmptyOrderDetail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: 150,
                    color: Colors.grey[400],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 20,
                    width: 150,
                    color: Colors.grey[400],
                  ),
                  SizedBox(
                    height: 25,
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: 150,
                    color: Colors.grey[400],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 20,
                    width: 150,
                    color: Colors.grey[400],
                  ),
                  SizedBox(
                    height: 25,
                  )
                ],
              ),
            ),
            EmptyCartItem(
              isAppliedCheckbox: false,
            ),
            EmptyCartItem(
              isAppliedCheckbox: false,
            ),
            Container(
              height: 25,
              width: double.infinity,
              color: Colors.grey[400],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 25,
              width: double.infinity,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
